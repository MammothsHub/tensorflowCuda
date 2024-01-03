# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_CONTAINER=$REGISTRY/$OWNER/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

WORKDIR /

#Clone into spack and install cuda 12.2
RUN git clone https://github.com/spack/spack.git && \
    source /spack/share/spack/setup-env.sh && \
    spack install cuda@12.2.0 

RUN echo "source /spack/share/spack/setup-env.sh && spack load cuda && export CUDA_DIR=$CUDA_HOME && export CUDA_PATH=$CUDA_HOME && export CUDA_ROOT=$CUDA_HOME && export CUDA_BIN=$CUDA_HOME/bin && export CUDA_LIB=$CUDA_HOME/lib64 && export CUDA_VER=12.2.0 && export CUDA_INSTALL_PATH=$CUDA_HOME && export CUDA_BIN_PATH=$CUDA_HOME && export PATH=$PATH:$CUDA_BIN && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_LIB && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/extras/CUPTI/lib64 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/include && export CPLUS_INCLUDE_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/include && export MANPATH=$CUDA_HOME/man " >> exportSpackCuda.sh

#Where are we? 
RUN echo $PWD

RUN chmod ugo+wrx /exportSpackCuda.sh && \
    rm -r -f /home/jovyan/.spack 

USER ${NB_UID}

WORKDIR	"${HOME}"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Changed a bit from original image, trying really hard to use correct verion
RUN /exportSpackCuda.sh && \
    pip install ai-benchmark && \
    pip install --no-cache-dir tensorflow && \ 
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" 

#Export spack's cuda 
#CMD /exportSpackCuda.sh     
    
