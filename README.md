# EKS end-to-end

- EKS with ingress controller, cert-manager, r53 etc

## How to

```bash

terraform init
terraform apply -var "name=cert-test" -var "domain_name={{your-domain-name}}"

```

export KUBECONFIG="$PWD/kubeconfig_{{name}}-eks"

## Ingress controller

```

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace="ingress-nginx"
```

## Cert manager

```bash

helm repo add jetstack https://charts.jetstack.io
helm upgrade cert-manager jetstack/cert-manager \
  --install \
  --namespace cert-manager \
  --create-namespace \
  --values "cert-manager-values.yml" \
  --wait

k apply -f issuer.yml

```

## Test deploy an app

- Deploy an apache pod, svc and an ingress. Add ingress class to it and the clusterissuer you created as an annotation


- The last thing is to add an A ALIAS record for the app domain name pointing to the ingress Load Balancer in the Route53 Hosted Zone.
- After the new DNS entry propagates you should be able to access the domain and see your app with a Let’s Encrypt signed SSL certificate!

`kubectl get certificate -n default`
