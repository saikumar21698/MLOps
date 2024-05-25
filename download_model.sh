#!/bin/bash
set -e

echo "Starting model and tokenizer download..."

python -c "
import logging
logging.basicConfig(level=logging.INFO)
from transformers import AutoTokenizer, AutoModelForCausalLM

try:
    logging.info('Downloading tokenizer...')
    tokenizer = AutoTokenizer.from_pretrained('gpt2')
    tokenizer.save_pretrained('/app/gpt2')
    logging.info('Downloading model...')
    model = AutoModelForCausalLM.from_pretrained('gpt2')
    model.save_pretrained('/app/gpt2')
    logging.info('Model and tokenizer downloaded and saved successfully.')
except Exception as e:
    logging.error(f'Error downloading the model: {e}')
    raise
"
