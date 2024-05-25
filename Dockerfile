FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

COPY ./app /app

RUN pip install transformers

# Set environment variable for Hugging Face API token
ENV HF_HOME=/root/.huggingface
ENV HF_HOME_API_KEY=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

RUN echo "url: https://huggingface.co" > $HF_HOME/transformers-cli.yaml && \
    echo "token: $HF_HOME_API_KEY" >> $HF_HOME/transformers-cli.yaml

