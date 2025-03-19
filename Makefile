NAMESPACE=service-namespace

COMMON_CHART=./common
JOB_EXAMPLE=./examples/job
SERVICE_EXAMPLE=./examples/service

OUTPUT_DIR=./charts

.PHONY: all
all: help

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make template-job          - Render templates for the job example"
	@echo "  make template-service      - Render templates for the service example"
	@echo "  make package-common        - Package the common chart into the $(OUTPUT_DIR) folder"
	@echo "  make update-deps-job       - Update dependencies for the job example"
	@echo "  make update-deps-service   - Update dependencies for the service example"
	@echo "  make publish               - Publish changes to GitHub"

.PHONY: template-job
template-job:
	helm -n $(NAMESPACE) template job $(JOB_EXAMPLE) --debug

.PHONY: template-service
template-service:
	helm -n $(NAMESPACE) template service $(SERVICE_EXAMPLE) --debug

.PHONY: package-common
package-common:
	mkdir -p $(OUTPUT_DIR)
	helm package $(COMMON_CHART) --destination $(OUTPUT_DIR)

.PHONY: update-deps-job
update-deps-job:
	helm dependency update $(JOB_EXAMPLE)

.PHONY: update-deps-service
update-deps-service:
	helm dependency update $(SERVICE_EXAMPLE)

.PHONY: publish
publish:
	git add .
	git commit -m "Updated Helm templates and packaged charts"
	git push origin main