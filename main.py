from ollama import chat
response = chat(model='gemma3:1b', messages=[
    {'role': 'user', 'content': 'Say hello from Python!'}
])
print(response['message']['content'])
