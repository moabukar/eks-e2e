# EKS end-to-end

- EKS with ingress controller, cert-manager, externalDNS, r53/azure dns etc. 

### Pre-req

```bash

export AWS_ACCESS_KEY_ID=<>
export AWS_SECRET_ACCESS_KEY=<>
export AWS_DEFAULT_REGION=<>

```

## How to

```bash

terraform init
terraform apply -var "name=cert-test" -var "domain_name=<>"

```

export KUBECONFIG="$PWD/kubeconfig_{{name}}-eks"

## Ingress controller

```bash

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
  --values "k8s/cert-manager-values.yml" \
  --wait

k apply -f issuer.yml

```

## ExternalDNS

- Either Azure or EKS. 
- If Azure, you need perms on the managed identities
  - Network contributor
  - DNS Zone contributor
- if AWS
  - Route53 Record Set perms
    ```json
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "route53:GetChange",
          "Resource" : "arn:aws:route53:::change/*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets"
          ],
          "Resource" : "*"
        },
      ]
    }
    ```
- Deploy via helm `helm install external-dns . -f values.yaml` (azure example)

## Test deploy an app

- Deploy an apache pod, svc and an ingress. Add ingress class to it and the clusterissuer you created as an annotation to the ingress.
- The last thing is to add an A ALIAS record for the app domain name pointing to the ingress Load Balancer in the Route53 Hosted Zone.
- After the new DNS entry propagates you should be able to access the domain and see your app with a Let’s Encrypt signed SSL certificate!

`kubectl get certificate -n default`

## ArgoCD with SSL

- `kubectl create namespace argocd`
- `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
- `kubectl apply -f argo/argo-ing.yml`


- `argocd login <ingress-host>` # Enter admin pass for argo (user is admin)
- `argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-server https://kubernetes.default.svc --dest-namespace default`
- `kubectl apply -f argo/guestbook.yml`
- access app in ingress host `argocd.sandbox.<domain>`
