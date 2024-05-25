from fastapi import FastAPI, Request
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

app = FastAPI()

# Load the tokenizer and model from the specified directory
tokenizer = AutoTokenizer.from_pretrained("/app/gpt2")
model = AutoModelForCausalLM.from_pretrained("/app/gpt2")

@app.post("/inference")
async def get_inference(request: Request):
    data = await request.json()
    input_text = data.get("text")
    if not input_text:
        return {"error": "Please provide text for inference"}
    
    inputs = tokenizer(input_text, return_tensors="pt")
    outputs = model.generate(**inputs)
    response_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    
    return {"response": response_text}
