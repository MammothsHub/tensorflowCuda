# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_CONTAINER=$REGISTRY/$OWNER/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

#We want cuda and spack installed on the top level directory 
#This ensures that jupyter doesn't alter them in any way
#But this requires us to be root and change WORKDIR  
#USER root
#WORKDIR /

#Clone into spack and install cuda 12.2
#RUN git clone https://github.com/spack/spack.git && \
#    source /spack/share/spack/setup-env.sh && \
#    spack install cuda@12.2.0 

#Copy over the spack cuda commands to top directory 
#COPY exportSpackCuda.sh /

#Change permissions so anyone can run it
#RUN chmod ugo+wrx /exportSpackCuda.sh

#Remove the temporary .spack folder, not needed and messy 
#This will also ruin the fix-permissions later 
#RUN rm -r -f /home/jovyan/.spack 

#Change user back to jovyan
#USER ${NB_UID}

#Change workdir back to /home/jovyan
#WORKDIR	"${HOME}"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Now export spack's cuda and install packages 
RUN source /exportSpackCuda.sh && \
    pip install --upgrade pip && \
    pip install --no-cache-dir tensorflow-gpu[and-cuda] && \ 
    pip install new-ai-benchmark && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" 

#Export spack's cuda on container boot 
#CMD /exportSpackCuda.sh     
    
