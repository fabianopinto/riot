# Development Guide

This guide provides detailed instructions for developers working on RIoT.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Building](#building)
- [Debugging](#debugging)
- [Tools](#tools)

## Prerequisites

### Required

- **Go**: Version 1.21 or higher

  ```bash
  # Check Go version
  go version
  ```

- **Git**: For version control
  ```bash
  git --version
  ```

### Recommended

- **golangci-lint**: For code linting

  ```bash
  # Install on macOS
  brew install golangci-lint

  # Or using go install
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  ```

- **goimports**: For import management

  ```bash
  go install golang.org/x/tools/cmd/goimports@latest
  ```

- **GitHub CLI** (optional but recommended): For GitHub operations
  ```bash
  # Install on macOS
  brew install gh
  ```

### Install All Tools

```bash
make tools
```

## Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/riot.git
cd riot

# Add upstream remote
git remote add upstream https://github.com/fabianopinto/riot.git
```

### 2. Install Dependencies

```bash
# Download dependencies
make deps

# Verify everything works
make test
```

### 3. Set Up Git Hooks (Optional)

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
make check
```

Make it executable:

```bash
chmod +x .git/hooks/pre-commit
```

## Project Structure

```
riot/
├── cmd/                  # Command-line applications
│   └── riot/             # Main application
│       └── main.go       # Entry point
│
├── internal/             # Private application code
│   └── app/              # Application logic
│       ├── app.go        # Main app code
│       └── app_test.go   # Tests
│
├── pkg/                  # Public library code (reusable)
│
├── configs/              # Configuration files
│
├── scripts/              # Build and utility scripts
│
├── docs/                 # Documentation
│   └── DEVELOPMENT.md    # This file
│
├── .github/              # GitHub-specific files
│   └── workflows/        # CI/CD workflows
│
├── go.mod                # Go module definition
├── go.sum                # Dependency checksums
├── Makefile              # Build automation
├── .golangci.yml         # Linter configuration
├── README.md             # Project overview
├── CONTRIBUTING.md       # Contribution guidelines
└── LICENSE               # MIT License
```

## Development Workflow

### Creating a New Feature

1. **Create a branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Write code** following the [coding standards](../CONTRIBUTING.md#coding-standards)

3. **Write tests**:

   ```bash
   # Create or update test files
   # Run tests
   make test
   ```

4. **Format and lint**:

   ```bash
   make fmt
   make lint
   ```

5. **Commit changes**:

   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

6. **Push and create PR**:
   ```bash
   git push origin feature/your-feature-name
   # Create PR on GitHub
   ```

### Keeping Your Branch Updated

```bash
# Fetch latest changes
git fetch upstream

# Rebase your branch
git rebase upstream/main

# If conflicts, resolve them and continue
git rebase --continue

# Force push to your branch
git push --force-with-lease origin feature/your-feature-name
```

## Testing

### Running Tests

```bash
# Run all tests
make test

# Run specific package tests
go test ./internal/app/...

# Run with verbose output
go test -v ./...

# Run with coverage
make test-coverage

# Run with race detector
go test -race ./...
```

### Writing Tests

Follow table-driven test patterns:

```go
func TestFunction(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    string
        wantErr bool
    }{
        {
            name:    "valid input",
            input:   "test",
            want:    "test",
            wantErr: false,
        },
        {
            name:    "empty input",
            input:   "",
            want:    "",
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := Function(tt.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("Function() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if got != tt.want {
                t.Errorf("Function() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

## Building

### Local Build

```bash
# Build binary
make build

# Run binary
./bin/riot

# Or build and run
make run
```

### Cross-Platform Build

```bash
# Use GoReleaser for multi-platform builds
goreleaser build --snapshot --clean

# Binaries will be in dist/
```

## Debugging

### Using Delve

Install Delve:

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

Debug the application:

```bash
# Debug main package
dlv debug ./cmd/riot

# Debug with arguments
dlv debug ./cmd/riot -- arg1 arg2

# Debug tests
dlv test ./internal/app
```

### VS Code Configuration

Add to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Package",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "program": "${workspaceFolder}/cmd/riot"
    }
  ]
}
```

## Tools

### Makefile Targets

```bash
# View all available targets
make help

# Common targets:
make build          # Build the application
make test           # Run tests
make lint           # Run linter
make fmt            # Format code
make check          # Run all checks
make clean          # Remove build artifacts
make install        # Install binary
make tools          # Install development tools
```

### Linting

```bash
# Run linter
make lint

# Auto-fix issues
golangci-lint run --fix

# Run specific linters
golangci-lint run --disable-all --enable=errcheck,gosimple
```

### Code Generation

If you add code generation:

```bash
# Add to Makefile
generate:
	go generate ./...
```

## CI/CD

### GitHub Actions

Workflows are defined in `.github/workflows/`:

- **ci.yml**: Runs on every push/PR (test, lint, build)
- **codeql.yml**: Security scanning

### Local CI Testing

```bash
# Run the same checks as CI
make check

# Test snapshot release
make release-snapshot
```

## Environment Variables

If your application uses environment variables, create `.env`:

```bash
# .env (not committed)
LOG_LEVEL=debug
API_KEY=your-key-here
```

Load in code:

```go
import "github.com/joho/godotenv"

func init() {
    godotenv.Load()
}
```

## Troubleshooting

### Common Issues

1. **Tests failing**: Ensure dependencies are up to date

   ```bash
   make deps
   ```

2. **Linter errors**: Format code first

   ```bash
   make fmt
   ```

3. **Build errors**: Clean and rebuild
   ```bash
   make clean
   make build
   ```

### Getting Help

- Check [CONTRIBUTING.md](../CONTRIBUTING.md)
- Open an issue with the `question` label
- Start a discussion on GitHub Discussions

## Additional Resources

- [Effective Go](https://golang.org/doc/effective_go)
- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Project Layout](https://github.com/golang-standards/project-layout)
- [golangci-lint Documentation](https://golangci-lint.run/)
