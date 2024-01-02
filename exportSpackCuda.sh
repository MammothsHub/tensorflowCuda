#!/bin/bash

source spack/share/spack/setup-env.sh && \
    spack load cuda && \
    export CUDA_DIR=$CUDA_HOME && \
    export CUDA_PATH=$CUDA_HOME && \
    export CUDA_ROOT=$CUDA_HOME && \
    export CUDA_BIN=$CUDA_HOME/bin && \
    export CUDA_LIB=$CUDA_HOME/lib64 && \ 
    export CUDA_VER=12.2.0 && \
    export CUDA_INSTALL_PATH=$CUDA_HOME && \
    export CUDA_BIN_PATH=$CUDA_HOME && \
    export PATH=$PATH:$CUDA_BIN && \ 
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_LIB && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/extras/CUPTI/lib64 && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/include && \
    export CPLUS_INCLUDE_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/include && \
    export MANPATH=$CUDA_HOME/man 
