#!/bin/bash

set -e

export GANDIV5_API_KEY={{ gandi_api_key }}
LEGO_CERTS=/root/.lego/certificates

{% for domain in tls_cert_domains %}
lego \
{% for san in domain.sans %}
  --domains "{{ san }}" \
{% endfor %}
  --http --http.port :9999 \
  --dns gandiv5 \
  --email "{{ letsencrypt_email }}" \
  --accept-tos \
  --path /root/.lego \
  --dns.resolvers 1.1.1.1 \
  renew
cat ${LEGO_CERTS}/{{ domain.cert_name }}.crt \
  ${LEGO_CERTS}/{{ domain.cert_name }}.key \
  > /opt/certs/{{ domain.cert_name }}.pem

{% endfor %}

sv reload haproxy
