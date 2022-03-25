
.PHONY: create

create: # Create Enviroment and Deploy Pods
	@kubectl create namespace private-docker-registry
	@kubectl apply -f config/priv-registry-secrets.yaml
	@kubectl apply -f config/registry-configmap.yaml
	@kubectl apply -f config/registry-deployment.yaml
	@kubectl apply -f config/registry-services.yaml
	@echo "Throwing in the secret ingredients and giving a stir"
	@sleep 5
	@kubectl get all -n private-docker-registry

cleanup:
	@kubectl delete namespace private-docker-registry

nodeports:
	@kubectl apply -f config/registry-node-services.yaml

restart:
	@echo "... Restarting Pods ..."
	@kubectl rollout restart deployment private-docker-registry-cache -n private-docker-registry
	@kubectl rollout restart deployment private-docker-registry -n private-docker-registry
	@sleep 5
	@kubectl get all -n private-docker-registry

stats:
	@watch kubectl get all,ing -n private-docker-registry

reglogs:
	@watch kubectl logs deployment.apps/private-docker-registry -n private-docker-registry

cachelogs:
	@watch kubectl logs deployment.apps/private-docker-registry-cache -n private-docker-registry

alllogs:
	@kubectl logs deployment.apps/private-docker-registry -n private-docker-registry
	@kubectl logs deployment.apps/private-docker-registry-cache -n private-docker-registry
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
