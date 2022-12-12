#!/bin/bash

set -e

export GANDIV5_API_KEY={{ gandi_api_key }}
LEGO_CERTS=/root/.lego/certificates

{% for domain in tls_cert_domains %}
lego --eab \
  --kid "{{ zerossl_kid }}" \
  --hmac "{{ zerossl_hmac }}" \
{% for san in domain.sans %}
  --domains "{{ san }}" \
{% endfor %}
  --http --http.port :9999 \
  --dns gandiv5 \
  --email "{{ zerossl_email }}" \
  --accept-tos \
  --path /root/.lego \
  --server https://acme.zerossl.com/v2/DV90 \
  --dns.resolvers 1.1.1.1 \
  run
cat ${LEGO_CERTS}/{{ domain.cert_name }}.crt \
  ${LEGO_CERTS}/{{ domain.cert_name }}.key \
  > /opt/certs/{{ domain.cert_name }}.pem

{% endfor %}

sv reload haproxy
