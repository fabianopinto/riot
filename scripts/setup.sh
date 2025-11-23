#!/bin/bash

# RIoT Development Environment Setup Script
# This script sets up the development environment for the RIoT project

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup function
main() {
    log_info "Setting up RIoT development environment..."

    # Check Go installation
    if ! command_exists go; then
        log_error "Go is not installed. Please install Go 1.21 or higher."
        log_info "Visit: https://golang.org/doc/install"
        exit 1
    fi

    GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    log_info "Found Go version: $GO_VERSION"

    # Check Git installation
    if ! command_exists git; then
        log_error "Git is not installed. Please install Git."
        exit 1
    fi
    log_info "Found Git: $(git --version)"

    # Download Go dependencies
    log_info "Downloading Go dependencies..."
    go mod download
    go mod verify
    log_info "Dependencies downloaded successfully"

    # Install development tools
    log_info "Installing development tools..."

    if ! command_exists golangci-lint; then
        log_info "Installing golangci-lint..."
        go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
    else
        log_info "golangci-lint already installed"
    fi

    if ! command_exists goimports; then
        log_info "Installing goimports..."
        go install golang.org/x/tools/cmd/goimports@latest
    else
        log_info "goimports already installed"
    fi

    if ! command_exists goreleaser; then
        log_info "Installing goreleaser..."
        go install github.com/goreleaser/goreleaser/v2@latest
    else
        log_info "goreleaser already installed"
    fi

    if ! command_exists syft; then
        log_info "Installing syft..."
        go install github.com/anchore/syft/cmd/syft@latest
    else
        log_info "syft already installed"
    fi

    # Check for GitHub CLI (optional)
    if ! command_exists gh; then
        log_warn "GitHub CLI (gh) not found. Install it for better GitHub integration."
        log_info "Visit: https://cli.github.com/"
    else
        log_info "Found GitHub CLI: $(gh --version | head -n 1)"
    fi

    # Set up Git hooks (optional)
    setup_git_hooks

    # Run initial checks
    log_info "Running initial checks..."
    if make check 2>/dev/null; then
        log_info "All checks passed!"
    else
        log_warn "Some checks failed. Run 'make check' to see details."
    fi

    # Summary
    log_info ""
    log_info "✅ Setup complete!"
    log_info ""
    log_info "Next steps:"
    log_info "  1. Run 'make build' to build the project"
    log_info "  2. Run 'make test' to run tests"
    log_info "  3. Run 'make run' to run the application"
    log_info "  4. See 'make help' for all available commands"
    log_info ""
    log_info "Documentation:"
    log_info "  - Development: docs/DEVELOPMENT.md"
    log_info "  - Workflow: docs/WORKFLOW.md"
    log_info "  - Contributing: CONTRIBUTING.md"
}

# Set up Git hooks
setup_git_hooks() {
    log_info "Setting up Git hooks..."

    HOOKS_DIR=".git/hooks"
    if [ ! -d "$HOOKS_DIR" ]; then
        log_warn "Git hooks directory not found. Are you in a Git repository?"
        return
    fi

    # Create pre-commit hook
    PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"

    if [ -f "$PRE_COMMIT_HOOK" ]; then
        log_info "Pre-commit hook already exists, skipping..."
    else
        cat > "$PRE_COMMIT_HOOK" << 'EOF'
#!/bin/bash
# Pre-commit hook for RIoT

echo "Running pre-commit checks..."

# Format code
echo "Formatting code..."
make fmt

# Run linter
echo "Running linter..."
if ! make lint; then
    echo "Linting failed. Please fix errors before committing."
    exit 1
fi

# Run tests
echo "Running tests..."
if ! make test; then
    echo "Tests failed. Please fix tests before committing."
    exit 1
fi

echo "All checks passed!"
EOF
        chmod +x "$PRE_COMMIT_HOOK"
        log_info "Pre-commit hook installed"
    fi
}

# Run main function
main "$@"
