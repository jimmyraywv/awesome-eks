Kubernetes provides a UI for administering a Kubernetes cluster known as the Kubernetes Dashboard.  This dashboard is ordinarily launched using kubectl proxy which proxies connection from a localhost address to the Kubernetes apiserver.  As of 3/19/18, the proxy service was not available in the EKS preview.  As a temporary workaround, you can run the dashboard as a service behind an public facing ELB.  Follow these instructions to get the dashboard running in your environment. 

```
export API_ENDPOINT=$(kubectl cluster-info | egrep -o '(http|https)://[a-zA-Z0-9\.]+' | head -1 | sed s/'https:\/\/'/''/g)
sed -e "s/\${API_ENDPOINT}/$API_ENDPOINT" kube-dashboard-secure.yaml > eks-dashboard.yaml
envsubst < kube-dashboard-secure.yaml > eks-dashboard.yaml
kubectl create -f eks-dashbaord.yaml
kubectl create serviceaccount admin-user -n kube-system
kubectl create clusterrolebinding admin-user-role-binding --clusterrole=cluster-admin --serviceaccount=kube-system:admin-user
kubectl get secrets --all-namespaces
kubectl get secret admin-user-token-<?????> -n kube-system --template='{{.data.token}}'
```
