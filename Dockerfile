FROM python:3.9-slim

WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

# Download and save the LLaMA-3B model
RUN set -x && \
    python -c "from transformers import AutoTokenizer, AutoModelForCausalLM; \
    AutoTokenizer.from_pretrained('Llama-3B').save_pretrained('/app/llama3'); \
    AutoModelForCausalLM.from_pretrained('Llama-3B').save_pretrained('/app/llama3')"

RUN sed -i "s|AutoTokenizer.from_pretrained('Llama-3B')|AutoTokenizer.from_pretrained('/app/llama3')|g" main.py
RUN sed -i "s|AutoModelForCausalLM.from_pretrained('Llama-3B')|AutoModelForCausalLM.from_pretrained('/app/llama3')|g" main.py

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]