from transformers import AutoModelForSequenceClassification, AutoTokenizer
model_path = "/mnt/code/sentence-transformers/examples/skt-en/output/skt-pli-en-dev/"
model = AutoModelForSequenceClassification.from_pretrained(model_path)
tokenizer = AutoTokenizer.from_pretrained(model_path)
# push model and tokenizer to huggingface hub
model.push_to_hub("buddhist-nlp/skt-eng-similarity")
tokenizer.push_to_hub("buddhist-nlp/skt-eng-similarity")
