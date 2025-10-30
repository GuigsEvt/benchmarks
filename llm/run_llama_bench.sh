#!/bin/bash

# Configuration
MODEL_NAME="DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf"
MODEL_PATH="./models/$MODEL_NAME"
HF_REPO="deepseek-ai/DeepSeek-R1-Distill-Qwen-7B-GGUF"
HF_FILENAME="DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Checking for model file: $MODEL_PATH${NC}"

# Check if model file exists
if [ ! -f "$MODEL_PATH" ]; then
    echo -e "${RED}Model file not found!${NC}"
    echo -e "${YELLOW}Downloading from Hugging Face...${NC}"
    
    # Create models directory if it doesn't exist
    mkdir -p ./models
    
    # Check if huggingface-hub is installed
    if ! python3 -c "import huggingface_hub" 2>/dev/null; then
        echo -e "${YELLOW}Installing huggingface-hub...${NC}"
        pip3 install huggingface-hub
    fi
    
    # Download the model using huggingface-hub
    echo -e "${YELLOW}Downloading $HF_FILENAME from $HF_REPO...${NC}"
    python3 -c "
from huggingface_hub import hf_hub_download
import os

try:
    file_path = hf_hub_download(
        repo_id='$HF_REPO',
        filename='$HF_FILENAME',
        local_dir='./models',
        local_dir_use_symlinks=False
    )
    print('Download completed successfully!')
except Exception as e:
    print(f'Error downloading model: {e}')
    exit(1)
"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to download model!${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Model downloaded successfully!${NC}"
else
    echo -e "${GREEN}Model file found!${NC}"
fi

# Check if llama-bench is available
if ! command -v llama-bench &> /dev/null; then
    echo -e "${RED}llama-bench command not found!${NC}"
    echo -e "${YELLOW}Please make sure llama.cpp is installed and llama-bench is in your PATH.${NC}"
    exit 1
fi

# Run llama-bench
echo -e "${YELLOW}Running llama-bench with model: $MODEL_PATH${NC}"
echo "Command: llama-bench --model $MODEL_PATH"
echo ""

llama-bench --model "$MODEL_PATH"