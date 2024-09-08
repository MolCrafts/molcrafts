#!/bin/sh
set -e

echo "Activating feature 'pytorch'"

which pip > /dev/null || (apt update && apt install python3-pip -y -qq)

if [ "${enable_cuda}" == "true" ]; then
    echo "Installing pytorch with CUDA support"
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu${cudaVersion}
    echo "Pytorch with CUDA support installed!"
else
    echo "Installing pytorch without CUDA support"
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    echo "Pytorch without CUDA support installed!"
fi

echo "pytorch installed! "