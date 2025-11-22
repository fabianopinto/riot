# Development Workflow Guide

This guide explains the complete workflow for commits, pull requests, and releases in the RIoT project.

## Table of Contents

- [Daily Development Workflow](#daily-development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Workflow](#pull-request-workflow)
- [Release Process](#release-process)
- [Hotfix Process](#hotfix-process)

## Daily Development Workflow

### 1. Start Your Day

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create a new feature branch
git checkout -b feature/your-feature-name
```

### 2. Make Changes

```bash
# Make your code changes
# Write tests for new functionality
# Update documentation as needed
```

### 3. Before Committing

```bash
# Run all checks locally
make check

# This runs:
# - make fmt    (format code)
# - make vet    (run go vet)
# - make lint   (run golangci-lint)
# - make test   (run tests)
```

### 4. Stage Your Changes

```bash
# Stage specific files
git add file1.go file2.go

# Or stage all changes
git add .

# Review what you're about to commit
git status
git diff --staged
```

## Commit Guidelines

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Build process or auxiliary tool changes
- **ci**: CI configuration changes

### Good Commit Examples

```bash
# Simple feature
git commit -m "feat: add user authentication"

# Bug fix with scope
git commit -m "fix(parser): handle empty input correctly"

# Documentation update
git commit -m "docs: update installation instructions"

# With body
git commit -m "refactor: simplify error handling

Replaced multiple if-else statements with a switch statement
for better readability and maintainability."

# Breaking change
git commit -m "feat: redesign configuration API

BREAKING CHANGE: The configuration file format has changed from JSON to YAML.
See migration guide in docs/migration.md"
```

### Making Good Commits

**DO:**

- Keep commits atomic (one logical change per commit)
- Write clear, descriptive messages
- Explain why, not just what
- Reference issues when relevant (`fixes #123`, `relates to #456`)

**DON'T:**

- Mix multiple unrelated changes
- Use vague messages like "fix stuff" or "update"
- Include WIP commits in PRs (squash them first)
- Commit commented-out code or debug statements

### Amending Commits

```bash
# If you forgot something in the last commit
git add forgotten-file.go
git commit --amend --no-edit

# If you want to update the commit message
git commit --amend
```

## Pull Request Workflow

### Step 1: Prepare Your Branch

```bash
# Ensure your branch is up to date
git fetch upstream
git rebase upstream/main

# If conflicts occur, resolve them
git status
# ... resolve conflicts ...
git add .
git rebase --continue

# Push to your fork
git push origin feature/your-feature-name

# For rebased branches (force push)
git push --force-with-lease origin feature/your-feature-name
```

### Step 2: Create Pull Request

#### Using GitHub Web Interface

1. Navigate to https://github.com/fabianopinto/riot
2. Click "Pull requests" → "New pull request"
3. Click "compare across forks"
4. Select your fork and branch
5. Fill out the PR template
6. Click "Create pull request"

#### Using GitHub CLI

```bash
# Create PR from command line
gh pr create --fill

# Or with more options
gh pr create \
  --title "feat: add new feature" \
  --body "Description of changes" \
  --label "enhancement" \
  --base main
```

### Step 3: PR Template Checklist

Make sure you complete all items in the PR template:

- [ ] Type of change selected
- [ ] Related issues linked
- [ ] Changes described
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (Unreleased section)
- [ ] All checks passing

### Step 4: Address Review Feedback

```bash
# Make requested changes
# Commit them
git add .
git commit -m "fix: address review feedback"

# Push to update the PR
git push origin feature/your-feature-name
```

### Step 5: Merge

Once approved and CI passes:

1. Ensure branch is up to date
2. Maintainer will merge (squash merge or rebase merge)
3. Delete your feature branch

```bash
# After merge, clean up
git checkout main
git pull upstream main
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

## Release Process

### Release Types

- **Major** (X.0.0): Breaking changes
- **Minor** (x.Y.0): New features, backwards compatible
- **Patch** (x.y.Z): Bug fixes, backwards compatible

### Creating a Release

#### Step 1: Update CHANGELOG.md

```bash
# Create release branch
git checkout -b release/v1.2.0 main

# Edit CHANGELOG.md
# 1. Change [Unreleased] to [1.2.0] - YYYY-MM-DD
# 2. Add new [Unreleased] section at top
# 3. Review all changes are documented
```

Example CHANGELOG.md update:

```markdown
## [Unreleased]

## [1.2.0] - 2024-11-21

### Added

- New feature X
- Support for Y

### Fixed

- Bug in Z component

### Changed

- Improved performance of A
```

#### Step 2: Create and Push Tag

```bash
# Commit changelog
git add CHANGELOG.md
git commit -m "chore: prepare release v1.2.0"

# Create annotated tag
git tag -a v1.2.0 -m "Release version 1.2.0"

# Push commit and tag
git push upstream release/v1.2.0
git push upstream v1.2.0
```

#### Step 3: Automated Release

Once the tag is pushed, GitHub Actions automatically:

1. Runs all tests
2. Builds binaries for multiple platforms
3. Creates Docker images
4. Generates release notes from CHANGELOG.md
5. Publishes GitHub release
6. Updates Homebrew tap (if configured)

#### Step 4: Verify Release

```bash
# Using gh CLI
gh release view v1.2.0

# Or visit GitHub releases page
# https://github.com/fabianopinto/riot/releases
```

#### Step 5: Merge Release Branch

```bash
# Create PR to merge release branch back
gh pr create \
  --base main \
  --head release/v1.2.0 \
  --title "Release v1.2.0" \
  --body "Merge release v1.2.0 back to main"
```

### Testing Releases Locally

```bash
# Create a snapshot release without publishing
make release-snapshot

# Check the dist/ directory for binaries
ls -la dist/
```

## Hotfix Process

For critical bugs in production:

### Step 1: Create Hotfix Branch

```bash
# Branch from the release tag
git checkout -b hotfix/v1.2.1 v1.2.0

# Make the fix
# Write test
# Update CHANGELOG.md
```

### Step 2: Create Hotfix PR

```bash
# Push hotfix branch
git push origin hotfix/v1.2.1

# Create PR to main
gh pr create \
  --base main \
  --title "hotfix: fix critical bug in X" \
  --label "hotfix"
```

### Step 3: Release Hotfix

```bash
# After PR is merged, tag the hotfix
git checkout main
git pull upstream main
git tag -a v1.2.1 -m "Hotfix release v1.2.1"
git push upstream v1.2.1
```

## Using GitHub CLI (gh)

### Installation

```bash
# macOS
brew install gh

# Or download from https://cli.github.com/
```

### Authentication

```bash
gh auth login
```

### Common Commands

```bash
# Create PR
gh pr create --fill

# List PRs
gh pr list

# View PR
gh pr view 123

# Check PR status
gh pr status

# Checkout PR locally
gh pr checkout 123

# Merge PR
gh pr merge 123

# Create release
gh release create v1.2.0 --notes "Release notes here"

# View releases
gh release list

# Create issue
gh issue create --title "Bug report" --body "Description"
```

## Quick Reference

### Common Git Commands

```bash
# Status and diff
git status
git diff
git diff --staged

# Stashing changes
git stash
git stash pop
git stash list

# Branch management
git branch -a              # List all branches
git branch -d branch-name  # Delete local branch
git branch -D branch-name  # Force delete

# Remote operations
git fetch upstream
git pull upstream main
git push origin branch-name

# Rebase
git rebase main
git rebase -i HEAD~3       # Interactive rebase last 3 commits

# Reset
git reset HEAD~1           # Undo last commit, keep changes
git reset --hard HEAD~1    # Undo last commit, discard changes
```

### Makefile Commands

```bash
make help           # Show all available commands
make build          # Build the application
make test           # Run tests
make lint           # Run linter
make fmt            # Format code
make check          # Run all checks
make clean          # Clean build artifacts
make install        # Install binary
make run            # Build and run
make tools          # Install development tools
```

## Troubleshooting

### PR Conflicts

```bash
# Update your branch with main
git fetch upstream
git rebase upstream/main

# Resolve conflicts
# Edit conflicting files
git add .
git rebase --continue

# Force push
git push --force-with-lease origin your-branch
```

### Failed CI Checks

```bash
# Run checks locally to debug
make check

# View CI logs on GitHub
gh run list
gh run view <run-id>
```

### Reverting Changes

```bash
# Revert a commit
git revert commit-hash

# Revert a merge
git revert -m 1 merge-commit-hash
```

## Best Practices

1. **Commit frequently**: Make small, logical commits
2. **Test before committing**: Run `make check`
3. **Update often**: Regularly sync with upstream
4. **Review your own code**: Before creating PR, review your changes
5. **Communicate**: Use clear commit messages and PR descriptions
6. **Update CHANGELOG**: Always update for user-facing changes
7. **Ask for help**: Don't hesitate to ask questions in PRs or issues

## Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
