FROM ubuntu:22.04
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Generic installs
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git vim libarchive13 build-essential libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda clean --all --force-pkgs-dirs --yes && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Change the default shell command to shell wrapped in a conda env
# SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# Some more conda configuration
RUN . ~/.bashrc && \
    conda init bash && \
    conda activate base && \
    conda config --append channels conda-forge && \
    conda config --append channels bioconda

# Install mamba
RUN conda install mamba

# Copy dependency requirements
COPY conda_requirements.txt .
COPY requirements.txt .

# Install conda dependencies
RUN mamba install --yes --file conda_requirements.txt

# Install python dependencies
RUN python3 -m pip install -r requirements.txt

# Set up jupyterhub
RUN mkdir -p /opt/jupyterhub/etc/jupyterhub/
WORKDIR "/opt/jupyterhub/etc/jupyterhub/"
RUN jupyterhub --generate-config -f jupyterhub_config.py
COPY jupyterhub_config.py .
COPY users.txt .
RUN newusers users.txt

# Uncomment below if adding nbgitpuller link to home
# RUN mkdir templates
# COPY templates/* templates/

# tini for nice init, e.g. preventing lots of zombie processes
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
