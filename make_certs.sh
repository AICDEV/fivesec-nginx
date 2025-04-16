#!/bin/bash

set -euo pipefail

CERTS_DIR="certs"
mkdir -p "$CERTS_DIR"
cd "$CERTS_DIR" || exit 1

echo "[+] Generating Root CA..."
openssl genrsa -out root-ca.key 4096
openssl req -new -x509 -sha256 -key root-ca.key -subj "/C=CA/ST=NRW/L=ESSEN/O=ORG/OU=UNIT/CN=DE" -out root-ca.pem -days 1500

echo "[+] Generating Admin certificates."
openssl genrsa -out admin-temp.key 4096
openssl pkcs8 -inform PEM -outform PEM -in admin-temp.key -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin.key
openssl req -new -subj "/C=CA/ST=NRW/L=ESSEN/O=ORG/OU=UNIT/CN=ADMIN" -key admin.key -out admin.csr
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca.key -CAcreateserial -sha256 -out admin.pem

for NODE_NAME in "opensearch-node-1" "opensearch-node-2"
do
    openssl genrsa -out "$NODE_NAME-temp.key" 4096
    openssl pkcs8 -inform PEM -outform PEM -in "$NODE_NAME-temp.key" -topk8 -nocrypt -v1 PBE-SHA1-3DES -out "$NODE_NAME.key"
    openssl req -new -subj "/C=CA/ST=NRW/L=ESSEN/O=ORG/OU=UNIT/CN=$NODE_NAME" -key "$NODE_NAME.key" -out "$NODE_NAME.csr"
    openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:$NODE_NAME") -in "$NODE_NAME.csr" -CA root-ca.pem -CAkey root-ca.key -CAcreateserial -sha256 -out "$NODE_NAME.pem" -days 1499
    rm "$NODE_NAME-temp.key" "$NODE_NAME.csr"
done


echo "[+] Generating OpenSearch Dashboards certificate...consider to use your own..."
DASHBOARD_NAME="opensearch-dashboards"
openssl genrsa -out "$DASHBOARD_NAME-temp.key" 4096
openssl pkcs8 -inform PEM -outform PEM -in "$DASHBOARD_NAME-temp.key" -topk8 -nocrypt -v1 PBE-SHA1-3DES -out dashboard.key
openssl req -new -subj "/C=CA/ST=NRW/L=ESSEN/O=ORG/OU=UNIT/CN=$DASHBOARD_NAME" -key dashboard.key -out dashboard.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:$DASHBOARD_NAME") -in dashboard.csr -CA root-ca.pem -CAkey root-ca.key -CAcreateserial -sha256 -out dashboard.pem -days 1499
rm "$DASHBOARD_NAME-temp.key" dashboard.csr

cd ..

echo "[+] Change permissions from certs"
chmod -R 700 certs

#echo "[+] Create opensearch storage volumes"
#mkdir opensearch-data1
#mkdir opensearch-data2
#
#echo "[+] Change ownership of opensearch storage volumes"
#chown -R 1000:1000 opensearch-data1
#chown -R 1000:1000 opensearch-data2