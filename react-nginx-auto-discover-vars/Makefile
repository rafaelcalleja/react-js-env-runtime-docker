.PHONY: all
all: build start

.PHONY: build
build: deps

.PHONY: deps
deps:
	@@docker-compose build

.PHONY: start
start:
	@docker-compose up -d

.PHONY: stop
stop:
	@docker-compose down

.PHONY: clean
clean: stop

.PHONY: destroy
destroy:
	@docker-compose down --rmi local -v

.PHONY: logs
logs:
	@docker-compose logs -f

