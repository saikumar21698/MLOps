# Stage 1: Build stage with all dependencies
FROM python:3.10-slim as build

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-glx \
    libglib2.0-dev \
    libsm6 \
    libxext6 \
    libxrender1

# Set the working directory
WORKDIR /app

# Upgrade pip and install virtualenv
RUN python -m pip install --upgrade pip && pip install virtualenv

# Create and activate virtual environment
RUN python -m virtualenv venv
ENV PATH="/app/venv/bin:$PATH"

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage with only necessary components
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the virtual environment from the build stage
COPY --from=build /app/venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Copy the application code
COPY ./app /app

# Expose the port your application runs on
EXPOSE 8000

# Command to run the application
CMD ["/app/venv/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
