FROM debian:latest
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN /opt/conda/bin/conda install --yes ipython jupyter jupyterhub
RUN /opt/conda/bin/python3 -m pip install -r requirements.txt

# CASE 2
# Uncomment below if you have conda packages
# RUN /opt/conda/bin/conda config --append channels conda-forge
# RUN /opt/conda/bin/python3 -m conda install --yes --file conda_requirements.txt

RUN mkdir -p /opt/jupyterhub/etc/jupyterhub/
WORKDIR "/opt/jupyterhub/etc/jupyterhub/"
RUN /opt/conda/bin/jupyterhub --generate-config -f jupyterhub_config.py
COPY jupyterhub_config.py .
COPY users.txt 
RUN newusers users.txt

# CASE 3
# Uncomment below if adding nbgitpuller link to home
# RUN mkdir templates
# COPY templates/* templates/

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
