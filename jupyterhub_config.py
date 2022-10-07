c.JupyterHub.template_paths = ["/opt/jupyterhub/etc/jupyterhub/templates"]
c.JupyterHub.admin_access = True

c.NotebookApp.terminado_settings = {"shell_command": ["/bin/bash"]}
c.Spawner.env_keep = ["SHELL", "PATH"]

# CASE 4
# Uncomment below if setting up Apache with a specific outside-facing URL
c.JupyterHub.bind_url = "https://0.0.0.0:8000/biosb_metagenomics"
c.LocalAuthenticator.create_system_users = True
c.Authenticator.whitelist = {"user1", "user2"}
c.Authenticator.admin_users = {"useradmin"}
