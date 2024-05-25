# FastAPI: A modern, fast (high-performance) web framework for building APIs with Python 3.7+ focusing on simplicity, security, and scalability.
# Request: A FastAPI class to handle incoming request data.
# transformers: A library by Hugging Face that provides general-purpose architectures for natural language understanding and generation.
# torch: A library for tensor computations and deep learning (specifically PyTorch).

from fastapi import FastAPI, Request
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

# app is an instance of the FastAPI class. This instance will be used to define endpoints and application configuration.
app = FastAPI()


# AutoTokenizer.from_pretrained("Llama-3B"): Downloads and initializes the tokenizer for the LLaMA 3B model.
# AutoModelForCausalLM.from_pretrained("Llama-3B"): Downloads and initializes the causal language model (LLaMA 3B).

tokenizer = AutoTokenizer.from_pretrained("Llama-3B")
model = AutoModelForCausalLM.from_pretrained("Llama-3B")

# This line uses FastAPI's decorator to define a POST endpoint /inference. The function get_inference will handle any POST requests to this endpoint.
# data = await request.json(): Asynchronously parses the incoming JSON request to a Python dictionary.
# input_text = data.get("text"): Retrieves the text field from the JSON data.
# If input_text is not provided, the function returns an error message indicating that text input is required. This is a form of input validation.
@app.post("/inference")
async def get_inference(request: Request):
    data = await request.json()
    input_text = data.get("text")
    if not input_text:
        return {"error": "Please provide text for inference"}
#  Uses the tokenizer to convert the input text into tokens and prepares it in the tensor format required by the model (return_tensors="pt" specifies PyTorch tensors).
# model.generate(**inputs): Uses the model to generate text based on the tokenized input. The **inputs let the inputs be passed as keyword arguments.   
    inputs = tokenizer(input_text, return_tensors="pt")
    outputs = model.generate(**inputs)
    response_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
# The tokenizer decodes the tensor output back into human-readable text. skip_special_tokens=True ensures that special tokens (such as padding or end-of-sentence markers) are excluded from the output.    
    return {"response": response_text}
# The function returns the generated text as a JSON response with the key response.