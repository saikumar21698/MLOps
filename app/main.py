from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
from langchain_huggingface import HuggingFacePipeline

# Create a FastAPI app instance
app = FastAPI()

# Load the tokenizer and model from the Hugging Face model hub
tokenizer = AutoTokenizer.from_pretrained("meta-llama/Meta-Llama-3-8B")
model = AutoModelForCausalLM.from_pretrained("meta-llama/Meta-Llama-3-8B")

# Create the Hugging Face pipeline
pipe = pipeline("text-generation", model=model, tokenizer=tokenizer, max_new_tokens=100)
hf = HuggingFacePipeline(pipeline=pipe)

# Define a Pydantic model for the request body
class PromptRequest(BaseModel):
    prompt: str

# Define the generate endpoint
@app.post("/generate/")
async def generate_text(request: PromptRequest):
    prompt = request.prompt
    try:
        response = hf.invoke(prompt)
        return {"generated_text": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
