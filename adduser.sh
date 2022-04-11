read -p "Registry User? : " REG_USER
read -s -p "Registry Password? : " REG_PASSWD
htpasswd -Bb htpasswd.auth $REG_USER $REG_PASSWD
export REG_HTPASSWD=$(cat htpasswd.auth | base64)

head -21 registry-secrets.yaml > temp.registry-secrets.yaml
echo "  HTPASSWD: "$(echo ${REG_HTPASSWD} | base64) >> temp.registry-secrets.yaml
mv temp.registry-secrets.yaml registry-secrets.yaml
