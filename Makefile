default: lint

.PHONY: lint

lint:
	@docker run -it --rm -v $$PWD/docs:/work -w /work sacloud/textlint:local .

docker-image:
	@echo "building sacloud/textlint:local"
	@docker build -t sacloud/textlint:local .github/actions/textlint