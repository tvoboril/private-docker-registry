
.PHONY: config
config:
	./configure

deploy: # Create Enviroment and Deploy Pods
	@kubectl create namespace registry
	@kubectl apply -f registry-secrets.yaml
	@kubectl apply -f registry-deployment.yaml
	@kubectl get all -n registry

teardown:
	@kubectl delete namespace registry

deploy-tls:
	./makecert.sh
	@kubectl create namespace registry
	@kubectl apply -f registry-secrets.yaml
	@kubectl apply -f priv.domain-tls.yaml
	@kubectl apply -f registry-deployment-tls.yaml
	@kubectl get all -n registry

nodeports:
	@kubectl apply -f registry-node-services.yaml

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

adduser:
	@./adduser.sh

push_new_user:
	@./adduser.sh
	@kubectl apply -f registry-secrets.yaml
