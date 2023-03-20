# Devops-Challenges

# Challenge #1
# Website in Docker

The goal of this challenge is to be able to run a website or application with its own database inside a Docker environment.

- 1 container for the Website/Application (e.g. WordPress)
- 1 container for the database (e.g. MySQL)
- They should be defined in a docker-compose file
- They should run in their own Docker network
- The website and its database must be able to retain any files/data/configuration, even if the containers crash
- The website should be accessible locally from port 8888 but should run under another port inside the container (e.g. 80)
- **Bonus points**
    - Add a web server container (e.g. Nginx) in front of the website. The Nginx will first receive the user’s traffic and forward it to the website container
    - The web server container exposes an HTTPS/TLS endpoint (e.g. https://localhost:8888) and serves a self-signed certificate
    - Deploy 2 instances of the website container and have the web server load balance the traffic on them
- **Mega Bonus points**
    - Make it run in the cloud
