.PHONY: help build test lint fmt clean install run coverage

# Default target
.DEFAULT_GOAL := help

# Variables
BINARY_NAME=riot
CMD_PATH=./cmd/riot
BUILD_DIR=./bin
GO=go
GOFLAGS=-v
LDFLAGS=-ldflags "-s -w"

## help: Display this help message
help:
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

## build: Build the application
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	$(GO) build $(GOFLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) $(CMD_PATH)
	@echo "Build complete: $(BUILD_DIR)/$(BINARY_NAME)"

## test: Run all tests
test:
	@echo "Running tests..."
	$(GO) test -v -race -coverprofile=coverage.out ./...

## test-coverage: Run tests with coverage report
test-coverage: test
	@echo "Generating coverage report..."
	$(GO) tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report: coverage.html"

## lint: Run golangci-lint
lint:
	@echo "Running linter..."
	@which golangci-lint > /dev/null || (echo "golangci-lint not found. Install it from https://golangci-lint.run/usage/install/" && exit 1)
	golangci-lint run --timeout=5m

## fmt: Format code
fmt:
	@echo "Formatting code..."
	$(GO) fmt ./...
	goimports -w -local github.com/fabianopinto/riot .

## vet: Run go vet
vet:
	@echo "Running go vet..."
	$(GO) vet ./...

## check: Run all checks (fmt, vet, lint, test)
check: fmt vet lint test
	@echo "All checks passed!"

## clean: Remove build artifacts
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
	@rm -f coverage.out coverage.html
	@$(GO) clean
	@echo "Clean complete"

## install: Install the binary
install: build
	@echo "Installing $(BINARY_NAME)..."
	$(GO) install $(CMD_PATH)
	@echo "Installed to $(shell go env GOPATH)/bin/$(BINARY_NAME)"

## run: Build and run the application
run: build
	@echo "Running $(BINARY_NAME)..."
	$(BUILD_DIR)/$(BINARY_NAME)

## deps: Download and verify dependencies
deps:
	@echo "Downloading dependencies..."
	$(GO) mod download
	$(GO) mod verify
	@echo "Dependencies ready"

## tidy: Tidy and verify module dependencies
tidy:
	@echo "Tidying dependencies..."
	$(GO) mod tidy
	$(GO) mod verify

## upgrade: Upgrade all dependencies
upgrade:
	@echo "Upgrading dependencies..."
	$(GO) get -u ./...
	$(GO) mod tidy

## tools: Install development tools
tools:
	@echo "Installing development tools..."
	go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/goreleaser/goreleaser/v2@latest
	go install github.com/git-chglog/git-chglog/cmd/git-chglog@latest
	go install github.com/anchore/syft/cmd/syft@latest
	@echo "Tools installed"

## release-snapshot: Create a snapshot release (no publish)
release-snapshot:
	@echo "Creating snapshot release..."
	goreleaser release --snapshot --clean

## docker-build: Build Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(BINARY_NAME):latest .

## docker-run: Run Docker container
docker-run: docker-build
	@echo "Running Docker container..."
	docker run --rm $(BINARY_NAME):latest

## changelog: Generate CHANGELOG.md from git history
changelog:
	@echo "Generating CHANGELOG.md..."
	@if command -v git-chglog > /dev/null; then \
		git-chglog -o CHANGELOG.md; \
		echo "CHANGELOG.md updated"; \
	else \
		echo "git-chglog not found. Run 'make tools' to install it."; \
		exit 1; \
	fi

## changelog-next: Preview changelog for next release
changelog-next:
	@echo "Preview of changes since last tag:"
	@if command -v git-chglog > /dev/null; then \
		LAST_TAG=$$(git describe --tags --abbrev=0 2>/dev/null || echo ""); \
		if [ -z "$$LAST_TAG" ]; then \
			echo "No tags found. Showing all commits:"; \
			git-chglog --next-tag v0.1.0; \
		else \
			NEXT_TAG=$$(echo $$LAST_TAG | awk -F. '{$$NF = $$NF + 1;} 1' OFS=.); \
			git-chglog --next-tag $$NEXT_TAG $$LAST_TAG..; \
		fi \
	else \
		echo "git-chglog not found. Run 'make tools' to install it."; \
		exit 1; \
	fi

## release-prepare: Prepare for a new release (version bump)
release-prepare:
	@echo "Preparing release..."
	@read -p "Enter version (e.g., v1.0.0): " version; \
	if [ -z "$$version" ]; then \
		echo "Version cannot be empty"; \
		exit 1; \
	fi; \
	echo "Updating CHANGELOG.md for $$version..."; \
	git-chglog --next-tag $$version -o CHANGELOG.md; \
	echo "CHANGELOG.md updated for $$version"; \
	echo ""; \
	echo "Next steps:"; \
	echo "  1. Review CHANGELOG.md"; \
	echo "  2. git add CHANGELOG.md"; \
	echo "  3. git commit -m 'chore: prepare $$version release'"; \
	echo "  4. git tag -a $$version -m 'Release $$version'"; \
	echo "  5. git push origin main && git push origin $$version"
