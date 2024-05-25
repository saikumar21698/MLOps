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

# Copy the script that downloads the model and tokenizer.
COPY download_model.sh /app/download_model.sh

# Make the script executable
RUN chmod +x /app/download_model.sh

# Run the script to download the tokenizer and model.
RUN /app/download_model.sh

# Expose port 8000, which is the default port FastAPI will run on inside the container.
EXPOSE 8000

# The command runs the FastAPI application using Uvicorn at host 0.0.0.0 on port 8000.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
