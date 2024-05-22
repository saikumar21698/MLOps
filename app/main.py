from fastapi import FastAPI
from pydantic import BaseModel
import torch
from transformers import LlamaTokenizer, LlamaForCausalLM

app = FastAPI()

tokenizer = LlamaTokenizer.from_pretrained("facebook/llama-8b")
model = LlamaForCausalLM.from_pretrained("facebook/llama-8b")

class InputText(BaseModel):
    text: str

@app.post("/predict")
async def predict(input_text: InputText):
    inputs = tokenizer(input_text.text, return_tensors="pt")
    outputs = model.generate(**inputs)
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"response": response}