IMAGE := ollama
CONTAINER := slim-ollama

.PHONY: build run rebuild

build:
	-docker build -t $(IMAGE) .
	-docker run -d -p 11434:11434 -v ollama_data:/root/.ollama --name $(CONTAINER) $(IMAGE)

rebuild:
	-docker stop $(CONTAINER)
	-docker rm $(CONTAINER)
	-docker rmi $(IMAGE)
	make build

stop:
	-docker stop $(CONTAINER)

start:
	-docker start $(CONTAINER)