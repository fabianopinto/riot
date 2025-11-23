# Quick Start Guide

Get up and running with RIoT development in minutes.

## For New Contributors

### 1. Prerequisites

- **Go 1.21+**: [Install Go](https://golang.org/doc/install)
- **Git**: [Install Git](https://git-scm.com/downloads)
- **GitHub Account**: [Sign up](https://github.com)

### 2. Fork and Clone

```bash
# Fork the repo on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/riot.git
cd riot

# Add upstream
git remote add upstream https://github.com/fabianopinto/riot.git
```

### 3. Set Up Environment

```bash
# Run setup script (installs tools, dependencies)
./scripts/setup.sh

# Or manually:
make deps
make tools
```

### 4. Verify Setup

```bash
# Build the project
make build

# Run tests
make test

# Run linter
make lint
```

### 5. Make Changes

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make your changes, then:
make check  # Format, lint, and test

# Commit
git add .
git commit -m "feat: add my feature"

# Push
git push origin feature/my-feature
```

### 6. Create Pull Request

```bash
# Using GitHub CLI
gh pr create --fill

# Or visit GitHub and create PR manually
```

## Common Commands

### Build and Run

```bash
make build          # Build binary
make run            # Build and run
./bin/riot         # Run built binary
```

### Testing

```bash
make test           # Run all tests
make test-coverage  # Generate coverage report
go test -v ./...    # Verbose test output
```

### Code Quality

```bash
make fmt            # Format code
make lint           # Run linter
make vet            # Run go vet
make check          # Run all checks
```

### Development Tools

```bash
make tools          # Install dev tools
make clean          # Clean build artifacts
make help           # Show all commands
```

### Changelog Management

```bash
make changelog          # Generate CHANGELOG.md from git history
make changelog-next     # Preview changes for next release
make release-prepare    # Prepare release (updates changelog with version)
```

### Release Management

```bash
make release-snapshot   # Create local test release (no publish)
```

## Quick Workflows

### Adding a New Feature

```bash
# 1. Start from main
git checkout main
git pull upstream main

# 2. Create branch
git checkout -b feature/my-feature

# 3. Develop
# ... make changes ...
make check

# 4. Commit and push
git add .
git commit -m "feat: description"
git push origin feature/my-feature

# 5. Create PR
gh pr create --fill
```

### Fixing a Bug

```bash
# 1. Create branch
git checkout -b fix/bug-description

# 2. Fix and test
# ... make changes ...
make test

# 3. Commit
git commit -m "fix: description of fix"

# 4. Create PR
gh pr create --fill
```

### Updating Your PR

```bash
# After review feedback:
# 1. Make changes
# 2. Commit
git add .
git commit -m "fix: address review feedback"

# 3. Push
git push origin your-branch
```

## Commit Message Format

This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automated changelog generation.

### Format

```
<type>(<scope>): <subject>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `perf`: Performance
- `test`: Tests
- `chore`: Maintenance
- `ci`: CI/CD
- `build`: Build system

### Examples

```bash
feat: add user authentication
feat(api): add REST endpoint for users
fix: resolve memory leak in parser
fix(cli): handle empty input
docs: update installation guide
chore: update dependencies
```

### Breaking Changes

Add `BREAKING CHANGE:` in commit body for breaking changes:

```bash
git commit -m "feat: redesign API

BREAKING CHANGE: API endpoints restructured"
```

## Project Structure

```
riot/
├── cmd/riot/           # Main application
├── internal/           # Private code
├── pkg/                # Public libraries
├── docs/               # Documentation
├── .github/            # GitHub configs
├── scripts/            # Helper scripts
└── Makefile           # Build automation
```

## Getting Help

- **Documentation**: See `docs/` directory
- **Issues**: Open an issue on GitHub
- **Discussions**: GitHub Discussions
- **Contributing**: Read `CONTRIBUTING.md`

## Next Steps

1. Read [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
2. Read [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) - Detailed dev guide
3. Read [docs/WORKFLOW.md](docs/WORKFLOW.md) - Git workflow
4. Browse [existing issues](https://github.com/fabianopinto/riot/issues) - Find something to work on

## Tips

- Run `make check` before committing
- Write tests for new features
- Update CHANGELOG.md for user-facing changes
- Use conventional commits (`feat:`, `fix:`, etc.)
- Keep PRs focused and small
- Ask questions early and often

Happy coding! 🚀
