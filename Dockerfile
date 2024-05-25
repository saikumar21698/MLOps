# Use the official FastAPI image
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

# Install necessary dependencies
RUN pip install transformers uvicorn gunicorn fastapi

# Create the directory for Hugging Face configuration
RUN mkdir -p /root/.huggingface/

# Set up Hugging Face API token
RUN echo "url: https://huggingface.co" > /root/.huggingface/transformers-cli.yaml && \
    echo "token: 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" >> /root/.huggingface/transformers-cli.yaml
