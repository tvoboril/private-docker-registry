
.PHONY: config
config:
	./configure

deploy: # Create Enviroment and Deploy Pods
	@kubectl apply -f registry-deployment.yaml
	@kubectl get all -n registry

teardown:
	@kubectl delete -f registry-deployment.yaml

nodeports:
	@kubectl apply -f registry-node-services.yaml

restart:
	@echo "... Restarting Pods ..."
	@kubectl rollout restart deployment cache -n registry
	@kubectl rollout restart deployment registry -n registry
	@sleep 5
	@kubectl get all -n registry

stats:
	@watch kubectl get all,ing -n registry

reglogs:
	@watch kubectl logs deployment.apps/registry -n registry

cachelogs:
	@watch kubectl logs deployment.apps/cache -n registry

logs:
	@kubectl logs deployment.apps/registry -n registry
	@kubectl logs deployment.apps/cache -n registry
