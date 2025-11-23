# Contributing to RIoT

Thank you for your interest in contributing to RIoT! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Testing](#testing)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/riot.git
   cd riot
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/fabianopinto/riot.git
   ```
4. **Install dependencies**:
   ```bash
   go mod download
   ```
5. **Verify your setup**:
   ```bash
   make test
   ```

## Development Workflow

### 1. Create a Feature Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:

- `feature/` - for new features
- `fix/` - for bug fixes
- `docs/` - for documentation changes
- `refactor/` - for code refactoring
- `test/` - for adding tests

### 2. Make Your Changes

- Write clear, concise code
- Follow the coding standards (see below)
- Add tests for new functionality
- Update documentation as needed
- Keep commits atomic and focused

### 3. Run Tests and Linting

Before committing, ensure all tests pass and code is properly formatted:

```bash
# Run tests
make test

# Run linter
make lint

# Format code
make fmt

# Run all checks
make check
```

### 4. Commit Your Changes

Follow the commit message guidelines (see below):

```bash
git add .
git commit -m "feat: add new feature description"
```

### 5. Keep Your Branch Updated

Regularly sync with upstream:

```bash
git fetch upstream
git rebase upstream/main
```

### 6. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

## Pull Request Process

### Before Creating a PR

- [ ] All tests pass (`make test`)
- [ ] Code is formatted (`make fmt`)
- [ ] Linter passes (`make lint`)
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated (add to Unreleased section)
- [ ] Commits follow the commit message guidelines

### Creating the PR

1. Go to the [RIoT repository](https://github.com/fabianopinto/riot)
2. Click "New Pull Request"
3. Select your fork and branch
4. Fill out the PR template completely
5. Link any related issues

### PR Review Process

- At least one maintainer must approve the PR
- All CI checks must pass
- All review comments must be addressed
- PRs may be merged using squash merge or rebase merge

### After Your PR is Merged

1. Delete your feature branch:
   ```bash
   git branch -d feature/your-feature-name
   git push origin --delete feature/your-feature-name
   ```
2. Update your local main branch:
   ```bash
   git checkout main
   git pull upstream main
   ```

## Coding Standards

### Go Style Guide

- Follow the [Effective Go](https://golang.org/doc/effective_go) guidelines
- Use `gofmt` for formatting (enforced by CI)
- Follow the [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)

### Best Practices

- **Error Handling**: Always handle errors explicitly

  ```go
  if err != nil {
      return fmt.Errorf("failed to do something: %w", err)
  }
  ```

- **Naming**: Use clear, descriptive names

  - Packages: lowercase, single word
  - Functions: camelCase (exported) or mixedCase (unexported)
  - Constants: MixedCaps or UPPER_CASE for exported constants

- **Documentation**: Document all exported functions, types, and packages

  ```go
  // PackageName provides functionality for...
  package packagename

  // FunctionName does something specific.
  // It returns an error if...
  func FunctionName() error {
      // implementation
  }
  ```

- **Testing**: Write table-driven tests when possible

  ```go
  func TestFunction(t *testing.T) {
      tests := []struct {
          name    string
          input   string
          want    string
          wantErr bool
      }{
          // test cases
      }

      for _, tt := range tests {
          t.Run(tt.name, func(t *testing.T) {
              // test implementation
          })
      }
  }
  ```

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding or updating tests
- **chore**: Changes to build process or auxiliary tools
- **ci**: Changes to CI configuration files and scripts

### Examples

```
feat: add user authentication

fix: resolve memory leak in connection pool

docs: update installation instructions

refactor: simplify error handling in parser

test: add integration tests for API endpoints
```

### Breaking Changes

If your commit includes breaking changes, add `BREAKING CHANGE:` in the footer:

```
feat: redesign configuration API

BREAKING CHANGE: The configuration file format has changed from JSON to YAML.
Migration guide available in docs/migration.md
```

## Testing

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# Run specific package tests
go test ./internal/app/...

# Run with verbose output
go test -v ./...

# Run with race detector
go test -race ./...
```

### Writing Tests

- Place test files next to the code they test: `file.go` → `file_test.go`
- Use table-driven tests for multiple scenarios
- Use meaningful test names that describe what is being tested
- Test both success and failure cases
- Mock external dependencies

### Coverage

- Aim for at least 80% code coverage
- CI will report coverage for each PR
- Focus on testing critical paths and edge cases

## Questions?

- Open an issue for bugs or feature requests
- Start a discussion for questions or ideas
- Reach out to maintainers for guidance

Thank you for contributing to RIoT! 🎉
