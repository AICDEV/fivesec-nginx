# Fivesec-Nginx

## About

Fivesec-Nginx provides a custom-built and optimized Nginx setup with a focus on security and performance. This repository includes:
- A Dockerfile to compile Nginx from source with Brotli support.
- Preconfigured security and logging settings.
- Logstash integration to efficiently ship Nginx logs to OpenSearch for real-time monitoring and analytics.
- OpenSearch with OpenSearch Dashboards for log visualization.

## Features

- Builds Nginx from source with Brotli compression support ([ngx_brotli](https://github.com/google/ngx_brotli)).
- Configures logging settings and security options in `nginx.conf` (review before use).
- Sets up JSON logging for Nginx.
- Starts OpenSearch with OpenSearch Dashboards.
- Ships Nginx logs to OpenSearch via Logstash.

## Example
![image](https://github.com/fivesecde/fivesec-nginx/blob/main/example.png)

## Getting Started

### Prerequisites

Ensure you have Docker and the Docker Compose plugin installed on your system.

### Initial Setup

Since OpenSearch is configured to use TLS, you must generate the necessary certificates before starting the stack. Run:

```bash
./make_certs.sh
```

Then, set the correct file permissions:

```bash
chmod -R 750 ./certs
```

### Configuration

- Update or replace the `.env` file, which contains the `OPENSEARCH_INITIAL_ADMIN_PASSWORD` value.
- Once configured, start the stack by running:

```bash
 docker compose up --build
```

## Accessing Services

### Nginx
Your Nginx server should now be accessible at:

- **http://localhost:8080**

### OpenSearch
Your OpenSearch instance should be accessible at:

- **https://localhost:5601**

Since the certificate is self-signed, you may need to manually trust it. Once logged in, create an index pattern for `webserver-logs`—this is where your Nginx logs will appear.

## Addional Help
If you need help/have questions, feel free to get in touch with us at every time by sending us an email
to security@fivesec.de or visit our homepage https://fivesec.de :-)

