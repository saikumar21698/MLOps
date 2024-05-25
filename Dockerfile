# Stage 1: Download and save the model
FROM python:3.9-slim AS model-download

WORKDIR /app
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN python -c "from transformers import AutoTokenizer, AutoModelForCausalLM; \
               AutoTokenizer.from_pretrained('Llama-3B').save_pretrained('/app/llama3'); \
               AutoModelForCausalLM.from_pretrained('Llama-3B').save_pretrained('/app/llama3')"

# Stage 2: Build the final application image
FROM python:3.9-slim

WORKDIR /app
COPY --from=model-download /app/llama3 /app/llama3
COPY . .

RUN pip install --no-cache-dir -r requirements.txt
RUN sed -i "s|AutoTokenizer.from_pretrained('Llama-3B')|AutoTokenizer.from_pretrained('/app/llama3')|g" main.py
RUN sed -i "s|AutoModelForCausalLM.from_pretrained('Llama-3B')|AutoModelForCausalLM.from_pretrained('/app/llama3')|g" main.py

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]