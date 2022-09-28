# JupyterHub Docker container

# Instructions:

## Setup: building/running

1. Clone this repo
2. Add all required users to users.txt
3. Add users to whitelist in jupyterhub_config.py
4. Add libraries to pip install in requirements.txt
5. Add libraries to conda install in conda_requirements.txt

#### Optional: Add nbgitpuller link to Home

8. Uncomment Case 3 lines in Dockerfile
9. Add nbgitpuller link to templates/home.html

#### Optional: Use Apache to expose the JupyterHub server via an outward-facing URL

10. Change the required lines in httpd_jupyterhub_confd
11. ...
12. Uncomment Case 4 lines in jupyterhub_config.py

## Build the Image

`docker build . -t <image_name>`

## Run container (from port 8001)

`docker run --publish 8000:8001 --detach --name container_name image_name:latest`

## Access server

Go to localhost:8001 or (url/subdomain_name if using Apache)

If using nbgitpuller:
Log in and go to the Control panel (top right) to see the download link

## Add new users

```bash
docker exec -it container_name bash
echo "username:password::::/home/username/:" > new_user.txt
newusers new_user.txt
```
