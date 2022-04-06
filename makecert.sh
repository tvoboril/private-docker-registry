openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out priv.domain.crt \
            -keyout priv.domain.key
kubectl create secret tls domain-tls --key="priv.domain.key" --cert="priv.domain.crt"  --dry-run=client -o yaml >> /priv.domain-tls.yaml
