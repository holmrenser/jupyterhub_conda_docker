c.JupyterHub.template_paths = ["/opt/jupyterhub/etc/jupyterhub/templates"]
c.JupyterHub.admin_access = True
# CASE 4
# Uncomment below if setting up Apache with a specific outside-facing URL
# c.JupyterHub.bind_url = "https://0.0.0.0:8000/subdomain_name"
c.LocalAuthenticator.create_system_users = True
c.Authenticator.whitelist = {'user1', 'user2'}
c.Authenticator.admin_users = {'useradmin'}

