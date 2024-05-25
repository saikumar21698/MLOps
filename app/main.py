from fastapi import FastAPI
from transformers import AutoTokenizer, AutoModelForCausalLM
# Create a FastAPI app instance
app = FastAPI()
# Load the tokenizer and model from the Hugging Face model hub
tokenizer = AutoTokenizer.from_pretrained("meta-llama/Meta-Llama-3-8B")
model = AutoModelForCausalLM.from_pretrained("meta-llama/Meta-Llama-3-8B")

# Define an endpoint to generate text based on input prompt
@app.post("/generate/")
async def generate_text(prompt: str):
      # Tokenize the input prompt
    inputs = tokenizer.encode_plus(prompt, return_tensors="pt", max_length=1024, truncation=True)
      # Generate text based on the input prompt using the loaded mod
    output = model.generate(**inputs, max_length=150)
        # Decode the generated output text and remove special tokens
    return tokenizer.decode(output[0], skip_special_tokens=True)
