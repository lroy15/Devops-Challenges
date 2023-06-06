### Configuration

Edit IAM role in main.tf (currently set as root for my personal account)

- terraform init

- terraform apply

- aws eks update-kubeconfig --name LJ-eks --region us-east-2

- k apply -f kube/webonlytest.yaml

- k apply -f kube/webservice.yaml

- k apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/aws/deploy.yaml

- k apply -f kube/test-ing.yaml
