# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_CONTAINER=$REGISTRY/$OWNER/scipy-notebook
FROM $BASE_CONTAINER

ENV =

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

#Install git 
#RUN apt-get install --no-install-recommends -y git

#Clone into spack and install cuda 12.2
RUN git clone https://github.com/spack/spack.git && \
    source spack/share/spack/setup-env.sh && \
    spack install cuda@12.2.0 

#Copy the commands needed to export spack's cuda
#COPY exportSpackCuda.sh /home/jovyan
#USER root 
#Update the permissions for spack's cuda 
#RUN chmod u+x /home/jovyan/exportSpackCuda.sh
#USER ${NB_UID}

RUN echo #!/bin/bash >> exportSpackCuda.sh \
    echo source spack/share/spack/setup-env.sh && >> exportSpackCuda.sh \
    spack load cuda && >> exportSpackCuda.sh \
    export CUDA_DIR=$CUDA_HOME && >> exportSpackCuda.sh \
    export CUDA_PATH=$CUDA_HOME && >> exportSpackCuda.sh \
    export CUDA_ROOT=$CUDA_HOME && >> exportSpackCuda.sh \
    export CUDA_BIN=$CUDA_HOME/bin && >> exportSpackCuda.sh \
    export CUDA_LIB=$CUDA_HOME/lib64 && >> exportSpackCuda.sh \ 
    export CUDA_VER=12.2.0 && >> exportSpackCuda.sh \
    export CUDA_INSTALL_PATH=$CUDA_HOME && >> exportSpackCuda.sh \
    export CUDA_BIN_PATH=$CUDA_HOME && >> exportSpackCuda.sh \
    export PATH=$PATH:$CUDA_BIN && >> exportSpackCuda.sh \ 
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_LIB && >> exportSpackCuda.sh \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/extras/CUPTI/lib64 && >> exportSpackCuda.sh \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/include && >> exportSpackCuda.sh \
    export CPLUS_INCLUDE_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/include && >> exportSpackCuda.sh \
    export MANPATH=$CUDA_HOME/man >> exportSpackCuda.sh

RUN chmod u+x exportSpackCuda.sh

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#RUN pip install cuda-python && \
#    pip install --no-cache-dir tensorflow && \ 
#    pip install ai-benchmark && \ 
#    fix-permissions "${CONDA_DIR}" && \
#    fix-permissions "/home/${NB_USER}"

# Changed a bit from original image, trying really hard to use correct verion
RUN ./exportSpackCuda.sh && \
    pip install cuda-python && \
    pip install --no-cache-dir tensorflow && \
    pip install ai-benchmark && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

#Export spack's cuda 
CMD ./exportSpackCuda.sh     
    
