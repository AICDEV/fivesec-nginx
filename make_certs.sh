#!/bin/bash

set -euo pipefail

CERTS_DIR="certs"
mkdir -p "$CERTS_DIR"
cd "$CERTS_DIR" || exit 1

echo "[+] Generating Root CA..."
openssl genrsa -out root-ca.key 4096
openssl req -new -x509 -sha256 -key root-ca.key -subj "/C=CA/ST=ONTARIO/L=TORONTO/O=ORG/OU=UNIT/CN=CA" -out root-ca.pem -days 730

echo "[+] Generating Admin certificates."
openssl genrsa -out admin-temp.key 4096
openssl pkcs8 -inform PEM -outform PEM -in admin-temp.key -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin.key
openssl req -new -subj "/C=CA/ST=ONTARIO/L=TORONTO/O=ORG/OU=UNIT/CN=ADMIN" -key admin.key -out admin.csr
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca.key -CAcreateserial -sha256 -out admin.pem


echo "[+] Generating Dashboard certificates."
openssl genrsa -out dashboard-temp.key 4096
openssl pkcs8 -inform PEM -outform PEM -in dashboard-temp.key -topk8 -nocrypt -v1 PBE-SHA1-3DES -out dashboard.key
openssl req -new -subj "/C=CA/ST=ONTARIO/L=TORONTO/O=ORG/OU=UNIT/CN=DASHBOARD" -key dashboard.key -out dashboard.csr
openssl x509 -req -in dashboard.csr -CA root-ca.pem -CAkey root-ca.key -CAcreateserial -sha256 -out dashboard.pem
rm dashboard-temp.key dashboard.csr


for NODE_NAME in "opensearch-node1" "opensearch-node2"
do
    openssl genrsa -out "$NODE_NAME-temp.key" 4096
    openssl pkcs8 -inform PEM -outform PEM -in "$NODE_NAME-temp.key" -topk8 -nocrypt -v1 PBE-SHA1-3DES -out "$NODE_NAME.key"
    openssl req -new -subj "/C=CA/ST=ONTARIO/L=TORONTO/O=ORG/OU=UNIT/CN=$NODE_NAME" -key "$NODE_NAME.key" -out "$NODE_NAME.csr"
    openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:$NODE_NAME") -in "$NODE_NAME.csr" -CA root-ca.pem -CAkey root-ca.key -CAcreateserial -sha256 -out "$NODE_NAME.pem"
    rm "$NODE_NAME-temp.key" "$NODE_NAME.csr"
done

cd ..
chmod -R 750 ./certs

echo "[+] Certificate generation complete!"
