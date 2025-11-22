# Getting Started with RIoT Development

## 🎉 Project Successfully Created!

Your Go project **RIoT** has been set up with industry best practices for GitHub-hosted open-source projects.

## 📁 Project Structure

```
riot/
├── .github/                    # GitHub-specific files
│   ├── workflows/              # CI/CD pipelines
│   │   ├── ci.yml              # Continuous Integration
│   │   ├── release.yml         # Automated releases
│   │   └── codeql.yml          # Security scanning
│   ├── ISSUE_TEMPLATE/         # Issue templates
│   │   ├── bug_report.md
│   │   ├── feature_request.md
│   │   └── config.yml
│   └── PULL_REQUEST_TEMPLATE.md
│
├── cmd/                        # Command-line applications
│   └── riot/                   # Main application
│       └── main.go             # Entry point
│
├── internal/                   # Private application code
│   └── app/
│       ├── app.go              # Application logic
│       └── app_test.go         # Tests
│
├── pkg/                        # Public library code
│   └── .gitkeep
│
├── docs/                       # Documentation
│   ├── DEVELOPMENT.md          # Development guide
│   ├── WORKFLOW.md             # Git workflow guide
│   └── RELEASE.md              # Release process
│
├── scripts/                    # Helper scripts
│   ├── setup.sh                # Development setup
│   └── release.sh              # Release helper
│
├── .dockerignore               # Docker ignore file
├── .editorconfig               # Editor configuration
├── .gitignore                  # Git ignore file
├── .golangci.yml               # Linter configuration
├── .goreleaser.yml             # Release configuration
├── CHANGELOG.md                # Version history
├── CODE_OF_CONDUCT.md          # Code of conduct
├── CONTRIBUTING.md             # Contribution guidelines
├── Dockerfile                  # Docker image definition
├── LICENSE                     # MIT License
├── Makefile                    # Build automation
├── QUICKSTART.md               # Quick start guide
├── README.md                   # Project overview
├── SECURITY.md                 # Security policy
├── go.mod                      # Go module definition
└── go.sum                      # Dependency checksums
```

## 🚀 Initial Setup

### 1. Initialize Git Repository (if not already done)

```bash
cd ~/Projects/riot
git init
```

### 2. Create GitHub Repository

Using GitHub CLI:

```bash
gh repo create fabianopinto/riot --public --source=. --remote=origin
```

Or manually:

1. Go to https://github.com/new
2. Repository name: `riot`
3. Owner: `fabianopinto`
4. Make it public
5. Don't initialize with README (we already have one)

### 3. Connect and Push

```bash
# If using gh CLI (it already set the remote)
# Otherwise, add remote manually:
git remote add origin https://github.com/fabianopinto/riot.git

# Initial commit
git add .
git commit -m "feat: initial project setup

- Add standard Go project structure
- Configure CI/CD with GitHub Actions
- Add comprehensive documentation
- Set up linting and release automation"

# Push to GitHub
git branch -M main
git push -u origin main
```

### 4. Set Up Development Environment

```bash
# Run the setup script
./scripts/setup.sh

# Or manually install dependencies and tools
make deps
make tools
```

### 5. Verify Everything Works

```bash
# Build the project
make build

# Run tests
make test

# Run linter
make lint

# Run all checks
make check
```

## 📝 Next Steps

### Immediate Tasks

1. **Update README.md**

   - Add project description
   - Update features list
   - Add usage examples

2. **Configure GitHub Repository Settings**

   After creating your GitHub repository, complete these initial configuration tasks to ensure proper project management and security:

   - **Enable Issues and Discussions**: Activates GitHub's issue tracking system for bug reports and feature requests, plus Discussions for community conversations
   - **Set up branch protection rules**: Implements safeguards on the `main` branch to prevent direct pushes and enforce quality standards
   - **Configure required status checks**: Ensures CI/CD pipelines (tests, linting, builds) must pass before merging
   - **Enable Dependabot security updates**: Automatically monitors dependencies for security vulnerabilities and creates PRs to update them

   See detailed instructions below for each configuration step.

3. **Update SECURITY.md**

   - Add security contact email

4. **Start Developing**
   - Implement your application logic in `internal/app/`
   - Add public APIs in `pkg/` if needed
   - Write tests alongside your code

### Branch Protection Rules

Set these up on GitHub to protect your main branch and enforce code quality standards.

**Navigation**: GitHub Repository → Settings → Branches → Add rule

**Configuration Steps**:

1. **Branch name pattern**: `main`
   - Applies these protection rules specifically to the main branch

2. **✅ Require a pull request before merging**
   - Prevents direct commits to main
   - All changes must go through pull requests for review

3. **✅ Require approvals (1)**
   - At least one reviewer must approve the PR before merging
   - Ensures peer review and catches potential issues

4. **✅ Require status checks to pass before merging**
   - CI/CD workflows must succeed before merging
   - Select these required checks: `Test`, `Lint`, `Build`
   - Prevents merging code that breaks tests or fails quality standards

5. **✅ Require conversation resolution before merging**
   - All PR comments and discussions must be resolved
   - Ensures all feedback is addressed before merging

6. **✅ Do not allow bypassing the above settings**
   - Even administrators must follow these rules
   - No exceptions - maintains consistent code quality

These rules enforce code quality, peer review, and prevent accidental breaking changes to the main branch.

### Enable GitHub Features

Activate these GitHub features to enhance project management, security monitoring, and community engagement.

**Feature Activation Steps**:

1. **Issues**
   - **Navigation**: Repository Settings → Features → ✅ Enable Issues
   - **Purpose**: Enables bug tracking, feature requests, and task management
   - **Benefits**:
     - Works with the issue templates in `.github/ISSUE_TEMPLATE/`
     - Provides structured bug reports and feature requests
     - Integrates with project boards and milestones

2. **Discussions**
   - **Navigation**: Repository Settings → Features → ✅ Enable Discussions
   - **Purpose**: Provides a forum for community questions, ideas, and conversations
   - **Benefits**:
     - Separates general discussion from actionable issues
     - Creates a knowledge base through Q&A format
     - Builds community engagement without cluttering issues

3. **Dependabot**
   - **Navigation**: Repository Security → Code security → Enable Dependabot alerts
   - **Purpose**: Automatically scans Go dependencies for known vulnerabilities
   - **Benefits**:
     - Creates automated PRs to update vulnerable packages
     - Keeps your project secure with minimal manual effort
     - Provides detailed vulnerability information and remediation guidance

4. **Code Scanning (CodeQL)**
   - **Navigation**: Repository Security → Code security → Set up CodeQL
   - **Purpose**: Enables automated security analysis of your codebase
   - **Benefits**:
     - Detects potential security vulnerabilities and coding errors
     - Already configured via `.github/workflows/codeql.yml` in your project
     - Runs automatically on PRs and weekly schedules
     - Provides actionable security insights

These features provide comprehensive project management, security monitoring, and community engagement capabilities for your open-source Go project.

## 🔧 Development Workflow

### Daily Development

```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes and test
make check

# 3. Commit using conventional commits
git add .
git commit -m "feat: add new feature"

# 4. Push and create PR
git push origin feature/my-feature
gh pr create --fill
```

### Available Make Commands

```bash
make help            # Show all available commands
make build           # Build the application
make test            # Run tests
make test-coverage   # Generate coverage report
make lint            # Run linter
make fmt             # Format code
make check           # Run all checks (fmt, vet, lint, test)
make clean           # Clean build artifacts
make install         # Install binary
make run             # Build and run
make tools           # Install development tools
make release-snapshot # Test release locally
```

## 📖 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Quick start for contributors
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
- **[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)** - Detailed development guide
- **[docs/WORKFLOW.md](docs/WORKFLOW.md)** - Git workflow and PR process
- **[docs/RELEASE.md](docs/RELEASE.md)** - Release management

## 🎯 Workflow Examples

### Making Your First Commit

```bash
# 1. Make some changes to your code
# 2. Stage and commit
git add .
git commit -m "feat: implement user authentication

Added JWT-based authentication system with:
- User login/logout endpoints
- Token validation middleware
- Refresh token support"

# 3. Push
git push origin main
```

### Creating a Pull Request

```bash
# 1. Create and checkout branch
git checkout -b feature/user-profile

# 2. Make changes, test, and commit
make check
git commit -m "feat: add user profile management"

# 3. Push branch
git push origin feature/user-profile

# 4. Create PR using GitHub CLI
gh pr create --title "feat: add user profile management" \
             --body "Adds CRUD operations for user profiles" \
             --label "enhancement"

# Or create PR via GitHub web interface
```

### Creating a Release

```bash
# Use the release helper script
./scripts/release.sh 1.0.0

# Or manually:
# 1. Update CHANGELOG.md
# 2. Commit changes
git commit -m "chore: prepare release v1.0.0"

# 3. Create and push tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main
git push origin v1.0.0

# GitHub Actions will automatically:
# - Run tests
# - Build binaries for all platforms
# - Create GitHub release
# - Build and push Docker images
```

## 🔍 CI/CD Pipelines

### Continuous Integration (ci.yml)

Runs on every push and PR:

- ✅ Tests on Linux, macOS, Windows
- ✅ Linting with golangci-lint
- ✅ Security scanning with gosec
- ✅ Code coverage with Codecov

### Release Automation (release.yml)

Runs on version tags (v*.*.\*):

- ✅ Multi-platform builds
- ✅ Docker images
- ✅ GitHub releases
- ✅ Homebrew formula (configurable)

### Security Scanning (codeql.yml)

Runs weekly and on PRs:

- ✅ CodeQL analysis
- ✅ Vulnerability detection

## 🐛 Troubleshooting

### Common Issues

**Go modules issues:**

```bash
go mod tidy
go mod verify
```

**Linter not found:**

```bash
make tools
```

**Tests failing:**

```bash
make test-coverage  # See which tests fail
go test -v ./...    # Verbose output
```

### 📝 Note About Go Version

This project is configured for **Go 1.25+**. Make sure you have Go 1.25 or higher installed:

```bash
go version  # Should show go1.25.x or higher
```

### IDE YAML Lint Warnings

You may see warnings in `.golangci.yml` and `.goreleaser.yml`. These are **cosmetic IDE schema validation warnings** and can be safely ignored. The configurations use standard, widely-adopted formats that work correctly with the actual tools.

## 📚 Resources

### Go Resources

- [Effective Go](https://golang.org/doc/effective_go)
- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Go Project Layout](https://github.com/golang-standards/project-layout)

### Tools Documentation

- [golangci-lint](https://golangci-lint.run/)
- [GoReleaser](https://goreleaser.com/)
- [GitHub Actions](https://docs.github.com/en/actions)

### Git and GitHub

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

## 💡 Tips

1. **Run `make check` before committing** - Catches issues early
2. **Write tests first** - TDD leads to better code
3. **Keep PRs small** - Easier to review and merge
4. **Update CHANGELOG.md** - Users appreciate knowing what changed
5. **Use conventional commits** - Enables automated changelog generation
6. **Ask questions** - Open discussions or issues if unclear

## 🎊 You're All Set!

Your project is now ready for development. Start building amazing things with RIoT!

**Happy coding! 🚀**

---

For questions or issues, refer to:

- Documentation in `docs/`
- Open an issue on GitHub
- Start a discussion
