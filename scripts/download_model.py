from transformers import AutoModelForCausalLM, AutoTokenizer

model_id = "deepseek-ai/deepseek-coder-1.3b-instruct"
save_path = "/workspace/models/deepseek-coder-1.3b-instruct" # 원하는 경로

print(f"Downloading {model_id}...")
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, device_map="auto")

tokenizer.save_pretrained(save_path)
model.save_pretrained(save_path)
print(f"Model saved to {save_path}")

