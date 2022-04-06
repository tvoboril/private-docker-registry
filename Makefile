
.PHONY: create

create: # Create Enviroment and Deploy Pods
	@kubectl create namespace registry
	@kubectl apply -f /registry-secrets.yaml
	@
	@kubectl get all -n registry

cleanup:
	@kubectl delete namespace registry

nodeports:
	@kubectl apply -f config/registry-node-services.yaml

restart:
	@echo "... Restarting Pods ..."
	@kubectl rollout restart deployment registry-cache -n registry
	@kubectl rollout restart deployment registry -n registry
	@sleep 5
	@kubectl get all -n registry

stats:
	@watch kubectl get all,ing -n registry

reglogs:
	@watch kubectl logs deployment.apps/registry -n registry

cachelogs:
	@watch kubectl logs deployment.apps/registry-cache -n registry

alllogs:
	@kubectl logs deployment.apps/registry -n registry
	@kubectl logs deployment.apps/registry-cache -n registry
ingress:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/cloud/deploy.yaml
	@kubectl create namespace cert-manager
	@helm repo add jetstack https://charts.jetstack.io
	@helm repo update
	@helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \
  --set installCRDs=true
adduser:
	@htpasswd -Bc auth
