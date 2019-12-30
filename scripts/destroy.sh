set -x
#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing"

kubectl delete hr infra-flux -n flux

# TODO delete only HRs and then check for other stuff

# Create Namespaces
for NAMESPACE in $NAMESPACES; do 
  kubectl delete all --all -n $NAMESPACE && \
  kubectl delete configmap --all -n $NAMESPACE && \
  kubectl delete secrets --all -n $NAMESPACE && \
  kubectl delete ingress --all -n $NAMESPACE && \
  kubectl delete hr --all -n $NAMESPACE && \
  kubectl delete service --all -n $NAMESPACE && \
  kubectl delete pvc --all -n $NAMESPACE && \
  kubectl delete clusterrole --field-selector=metadata.namespace=$NAMESPACE && \
  kubectl delete role --field-selector=metadata.namespace=$NAMESPACE
done
helm reset --force
helm delete --purge helm-operator
kubectl delete crd helmreleases.helm.fluxcd.io
kubectl delete configmap -l OWNER=TILLER -n kube-system
kubectl delete namespaces $NAMESPACES