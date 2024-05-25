from fastapi import FastAPI
from transformers import AutoTokenizer, AutoModelForCausalLM

app = FastAPI()

tokenizer = AutoTokenizer.from_pretrained("meta-llama/Meta-Llama-3-8B")
model = AutoModelForCausalLM.from_pretrained("meta-llama/Meta-Llama-3-8B")


@app.post("/generate/")
async def generate_text(prompt: str):
    inputs = tokenizer(prompt, return_tensors="pt", max_length=1024, truncation=True)
    output = model.generate(**inputs, max_length=150)
    return tokenizer.decode(output[0], skip_special_tokens=True)
