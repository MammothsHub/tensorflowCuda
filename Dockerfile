# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_CONTAINER=$REGISTRY/$OWNER/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

#Install git 
#RUN apt-get install --no-install-recommends -y git

#Clone into spack and install cuda 12.2
RUN git clone https://github.com/spack/spack.git && \
    source spack/share/spack/setup-env.sh && \
    spack install cuda@12.2.0 

#Copy the commands needed to export spack's cuda
COPY exportSpackCuda.sh /home/jovyan

#Update the permissions for spack's cuda 
RUN chmod u+x /home/jovyan/exportSpackCuda.sh

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Changed a bit from original image, trying really hard to use correct verion
RUN /home/jovyan/exportSpackCuda.sh && \
    pip install cuda-python && \
    pip install --no-cache-dir tensorflow && \
    pip install ai-benchmark && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

#Export spack's cuda 
CMD /home/jovyan/exportSpackCuda.sh     
    
