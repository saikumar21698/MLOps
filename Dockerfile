# This line specifies the base Docker image to use, which includes Python 3.9 along with Uvicorn and Gunicorn, popular ASGI and WSGI servers for running Python web applications.
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

# This step installs the necessary Python packages (transformers, uvicorn, gunicorn, and fastapi) using pip, which are required to run the FastAPI application and utilize the Hugging Face Transformers library.
RUN pip install transformers uvicorn gunicorn fastapi langchain_huggingface

# This section creates a directory (/root/.huggingface/) where the Hugging Face Transformers library will store its configuration files. It then sets up the Hugging Face API token by creating a YAML file (transformers-cli.yaml) with the specified URL and token.
RUN mkdir -p /root/.huggingface/

# Set up Hugging Face API token
RUN echo "url: https://huggingface.co" > /root/.huggingface/transformers-cli.yaml && \
    echo "token: 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" >> /root/.huggingface/transformers-cli.yaml
#This command copies the Python code (app.py) from the local filesystem into the Docker container, specifically to the /app directory within the container.  
COPY ./app /app
#The copied Python code (app.py) would be executed when the container is started, as it contains the FastAPI application logic.\
WORKDIR /app

# Command to run the FastAPI app with Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]