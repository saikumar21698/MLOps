#!/bin/bash
set -e

echo "Starting model and tokenizer download..."

python -c "
import logging
logging.basicConfig(level=logging.INFO)
from transformers import AutoTokenizer, AutoModelForCausalLM

try:
    logging.info('Downloading tokenizer...')
    tokenizer = AutoTokenizer.from_pretrained('Llama-8B')
    tokenizer.save_pretrained('/app/llama8b')
    logging.info('Downloading model...')
    model = AutoModelForCausalLM.from_pretrained('Llama-8B')
    model.save_pretrained('/app/llama8b')
    logging.info('Model and tokenizer downloaded and saved successfully.')
except Exception as e:
    logging.error(f'Error downloading the model: {e}')
    raise
"
