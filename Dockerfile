# Use a FastAPI parent image
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11

# Copy your application code to the container
COPY ./ /app

# Install your dependencies
RUN pip install -r /app/requirements.txt