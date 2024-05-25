# Use the official Python image.
FROM python:3.9-slim

# Create a working directory.
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# Download and save the tokenizer and model if they don't exist in the cache
RUN if [ ! -d "/app/llama3" ]; then \
        python -c "from transformers import AutoTokenizer, AutoModelForCausalLM; \
               AutoTokenizer.from_pretrained('Llama-3B').save_pretrained('/app/llama3'); \
               AutoModelForCausalLM.from_pretrained('Llama-3B').save_pretrained('/app/llama3')"; \
    fi

# These commands update the paths in the main.py file to load the model and tokenizer from the saved local directory instead of downloading them during each container start.
RUN sed -i "s|AutoTokenizer.from_pretrained('Llama-3B')|AutoTokenizer.from_pretrained('/app/llama3')|g" main.py
RUN sed -i "s|AutoModelForCausalLM.from_pretrained('Llama-3B')|AutoModelForCausalLM.from_pretrained('/app/llama3')|g" main.py

# Exposes port 8000, which is the default port FastAPI will run on inside the container.
EXPOSE 8000

# The command runs the FastAPI application using Uvicorn at host 0.0.0.0 on port 8000.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]