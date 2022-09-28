# Single-click JupyterHub Docker container

# Instructions:
## Setup
### Case 1: Basic, no-frills
1. Clone this repo
2. Add all required users to users.txt
3. Add users to whitelist in jupyterhub\_config.py
4. Add libraries to pip install in requirements.txt

#### Case 2: Conda install libraries
5. Add libraries to conda install in conda\_requirements.txt
6. Uncomment Case 2 lines in Dockerfile
7. (Optional) Uncomment conda channels line in Dockerfile to add additional channels

#### Case 3: Add nbgitpuller link to Home
8. Uncomment Case 3 lines in Dockerfile
9. Add nbgitpuller link to templates/home.html

#### Case 4: Use Apache to expose the JupyterHub server via an outward-facing URL
10. Change the required lines in httpd\_jupyterhub\_confd
11. ...
12. Uncomment Case 4 lines in jupyterhub\_config.py

## Build the Image
`docker build . -t image_name`

## Run container (from port 8001)
`docker run --publish 8000:8001 --detach --name container_name image_name:latest`

## Access server
Go to localhost:8001 or (url/subdomain\_name if using Apache)

If using nbgitpuller:
	Log in and go to the Control panel (top right) to see the download link

## Add new users
```bash
docker exec -it container_name bash
echo "username:password::::/home/username/:" > new_user.txt
newusers new_user.txt
```




