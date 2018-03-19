Kubernetes provides a UI for administering a Kubernetes cluster known as the Kubernetes Dashboard.  This dashboard is ordinarily launched using kubectl proxy which proxies connection from a localhost address to the Kubernetes apiserver.  As of 3/19/18, the proxy service was not available in the EKS preview.  As a temporary workaround, you can run the dashboard as a service behind an public facing ELB.  Follow these instructions to get the dashboard running in your environment. 

```
export API_ENDPOINT=$(kubectl config view | grep server | cut -f 2- -d ":" | tr -d " " | sed s/'https:\/\/'/''/g)
envsubst < ./manifests/kube-dashboard-secure.yaml > ./manifests/eks-dashboard.yaml
```

Note: **envsubst** is part of the gettext utilities

```
kubectl create -f ./manifests/eks-dashbaord.yaml
```

Create a service account and secret to use to login to the dashboard

```
kubectl create serviceaccount admin-user -n kube-system
kubectl create clusterrolebinding admin-user-role-binding --clusterrole=cluster-admin --serviceaccount=kube-system:admin-user
```

Get the token associated with the service account

```
kubectl get secrets --all-namespaces
```

Replace <?????> with the random string of characters that get appended to the secret name

```
kubectl get secret admin-user-token-<?????> -n kube-system --template='{{.data.token}}'
```

Copy the token to your clipboard.  Get the URL of the load balancer fronting the dashboard. 

```
kubectl get services kubernetes-dashboard -n kube-system -o=jsonpath="{.status.loadBalancer.ingress[].hostname}
```

Paste the URL of the load balancer into a browser and login using the service account's bearer token.  Ignore the browser warnings that the site is unsecure. 
