# Devops-Challenges

# Challenge #1
# Website in Docker

The goal of this challenge is to be able to run a website or application with its own database inside a Docker environment.

- 1 container for the Website/Application (e.g. WordPress) ✔️
- 1 container for the database (e.g. MySQL) ✔️
- They should be defined in a docker-compose file ✔️
- They should run in their own Docker network ✔️
- The website and its database must be able to retain any files/data/configuration, even if the containers crash ✔️
- The website should be accessible locally from port 8888 but should run under another port inside the container (e.g. 80) ✔️
- **Bonus points**
    - Add a web server container (e.g. Nginx) in front of the website. The Nginx will first receive the user’s traffic and forward it to the website container ✔️
    - The web server container exposes an HTTPS/TLS endpoint (e.g. https://localhost:8888) and serves a self-signed certificate ✔️
    - Deploy 2 instances of the website container and have the web server load balance the traffic on them ✔️
- **Mega Bonus points**
    - Make it run in the cloud

# Challenge #2
# Local Kubernetes node/cluster

The goal of this challenge is to set up a local Kubernetes cluster (1 node or more if your tooling supports it) and run the website made in the first challenge inside of it.

- Read about the [basics of a local Kubernetes cluster](https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/)
- Set up a local Kubernetes cluster
    - You can use [Minikube to do it](https://kubernetes.io/docs/tutorials/hello-minikube/) or any other tool you’d like (e.g. KubeAdm)
- Go through the rest of [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) tutorials
- Deploy the containers you built in the first challenge in your K8S cluster
    - Should the Website container and the MySQL container be in the same pod or in different pods?
- Expose your Website with a K8S service in a way that you can reach it from a browser on your computer
    - **Note**: If your Kubernetes cluster/node is running inside a virtual machine, and you decide to expose your website on port 8888 on that virtual machine, you will most likely have to do some port-forwarding in your virtual machine agent. You can take a look at this link and go to the “**Forwarding Ports to a Virtual Machine**” section. Otherwise, feel free to hit me up and we’ll figure it out.

- **Bonus Points**
    - Scale your website to run at least 2 pods, both of them serving traffic
