# Challenge 1
## For running locally

This folder has everything needed except the SSL certificate files. In the docker-compose.yaml file the NGINX container points to a path on my ubuntu virtual machine for the certs so the user is vboxuser.

### Containers

1. nginx - the reverse proxy, forwarding requests from localhost:8888 to https://localhost:8888, which itself points to http://website:80 or http://website2:80

error_page 497 https://$server_name:8888$request_uri; - Had to add this line because nginx is running on nonstandard HTTPS port, so was getting 400 errors instead of redirecting correctly


2. website - the website service, running a basic nextjs website. It exposes port 80 but no ports are exposed on the host, so only containers in the same docker network can talk to it

3. db - a basic mysql database container

Testing:

curl -LI --insecure https://127.0.0.1:8888 (or http://127.0.0.1:8888)
