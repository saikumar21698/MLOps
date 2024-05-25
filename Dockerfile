# Use the official Python image.
FROM python:3.9-slim

# Create a working directory.
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# Install transformers and torch before downloading the model.
RUN pip install --no-cache-dir transformers torch

# This command downloads the tokenizer and model during the Docker image build and saves them locally to /app/llama8b.
RUN python -c "import logging; \
logging.basicConfig(level=logging.INFO); \
from transformers import AutoTokenizer, AutoModelForCausalLM; \
try: \
    logging.info('Downloading tokenizer...'); \
    tokenizer = AutoTokenizer.from_pretrained('Llama-8B'); \
    tokenizer.save_pretrained('/app/llama8b'); \
    logging.info('Downloading model...'); \
    model = AutoModelForCausalLM.from_pretrained('Llama-8B'); \
    model.save_pretrained('/app/llama8b'); \
    logging.info('Model and tokenizer downloaded and saved successfully.'); \
except Exception as e: \
    logging.error(f'Error downloading the model: {e}'); \
    raise"

# Exposes port 8000, which is the default port FastAPI will run on inside the container.
EXPOSE 8000

# The command runs the FastAPI application using Uvicorn at host 0.0.0.0 on port 8000.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
