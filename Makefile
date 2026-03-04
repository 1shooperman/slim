IMAGE := ollama
CONTAINER := slim-ollama

.PHONY: build run rebuild install-hook install-global

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

# Install prepare-commit-msg hook into this repo's .git/hooks with SLM_ROOT set to this repo.
install-hook:
	@mkdir -p .git/hooks && \
	printf '%s\n' '#!/bin/sh' 'export SLM_ROOT="$(CURDIR)"' 'exec "$$SLM_ROOT/scripts/prepare-commit-msg" "$$@"' > .git/hooks/prepare-commit-msg && \
	chmod +x .git/hooks/prepare-commit-msg

# Install hook globally so all new repos get it (git init / clone). Sets init.templatedir and slm.root
# so SLM_ROOT is not required per repo. Run from the slm repo. Existing repos do not get the hook
# unless you re-init or copy the hook; new repos created after this will.
install-global:
	@mkdir -p $(HOME)/.git_templates/hooks && \
	printf '%s\n' '#!/bin/sh' 'SLM_ROOT=$$(git config --global --get slm.root)' 'export SLM_ROOT' 'exec "$$SLM_ROOT/scripts/prepare-commit-msg" "$$@"' > $(HOME)/.git_templates/hooks/prepare-commit-msg && \
	chmod +x $(HOME)/.git_templates/hooks/prepare-commit-msg && \
	git config --global init.templatedir '$(HOME)/.git_templates' && \
	git config --global slm.root '$(CURDIR)'