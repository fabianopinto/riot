# Release Management Guide

This document describes the release process for the RIoT project.

## Release Strategy

RIoT follows [Semantic Versioning](https://semver.org/) (SemVer):

- **MAJOR** version (X.0.0): Incompatible API changes
- **MINOR** version (x.Y.0): New functionality, backwards compatible
- **PATCH** version (x.y.Z): Backwards compatible bug fixes

## Release Schedule

- **Major releases**: As needed (breaking changes accumulated)
- **Minor releases**: Monthly or when significant features are ready
- **Patch releases**: As needed for critical bug fixes

## Conventional Commits

This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automated changelog generation.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no logic change)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **ci**: CI/CD changes
- **build**: Build system changes

### Examples

```bash
feat: add user authentication
feat(api): add REST endpoint for user management
fix: resolve null pointer in config parser
fix(cli): handle empty input gracefully
docs: update installation instructions
chore: update dependencies
```

### Breaking Changes

For breaking changes, add `BREAKING CHANGE:` in the footer:

```bash
git commit -m "feat: redesign API structure

BREAKING CHANGE: API endpoints have been restructured"
```

## Pre-Release Checklist

Before creating a release, ensure:

- [ ] All planned features/fixes are merged
- [ ] All CI checks are passing
- [ ] CHANGELOG.md is up to date (use `make changelog-next` to preview)
- [ ] Documentation is updated
- [ ] Dependencies are up to date (`go get -u ./...`)
- [ ] All tests pass (`make test`)
- [ ] Manual testing completed for critical paths
- [ ] Security scan passed
- [ ] Performance benchmarks are acceptable

## Release Process

### 1. Prepare the Release

```bash
# Ensure main is up to date
git checkout main
git pull upstream main

# Create release branch
git checkout -b release/v1.2.0
```

### 2. Update CHANGELOG.md

#### Option A: Automated (Recommended)

Use git-chglog to automatically generate changelog from commit messages:

```bash
# Preview changes for next release
make changelog-next

# Prepare release with version
make release-prepare
# Then enter version when prompted (e.g., v1.2.0)
```

This requires using [Conventional Commits](https://www.conventionalcommits.org/) format:

```bash
# Examples of conventional commits
git commit -m "feat: add new authentication method"
git commit -m "fix: resolve memory leak in parser"
git commit -m "docs: update API documentation"
git commit -m "chore: update dependencies"
```

#### Option B: Manual

Edit `CHANGELOG.md` manually:

```markdown
## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [1.2.0] - 2024-11-21

### Added

- Feature A
- Feature B

### Fixed

- Bug fix C

[1.2.0]: https://github.com/fabianopinto/riot/compare/v1.1.0...v1.2.0
```

### 3. Update Version References

If you have version constants in code:

```go
// cmd/riot/version.go
package main

const version = "1.2.0"
```

### 4. Commit Changes

```bash
git add CHANGELOG.md
git commit -m "chore: prepare release v1.2.0"
git push origin release/v1.2.0
```

### 5. Create Pull Request

```bash
gh pr create \
  --base main \
  --title "Release v1.2.0" \
  --body "Preparing release v1.2.0

## Changes
See CHANGELOG.md for details.

## Checklist
- [x] CHANGELOG.md updated
- [x] All tests passing
- [x] Documentation updated"
```

### 6. Review and Merge

- Wait for CI checks to pass
- Get approval from maintainers
- Merge PR to main

### 7. Create and Push Tag

```bash
# Checkout main and pull
git checkout main
git pull upstream main

# Create annotated tag
git tag -a v1.2.0 -m "Release version 1.2.0

## Changes
- Feature A: Description
- Feature B: Description
- Bug fix C: Description

See CHANGELOG.md for full details."

# Push tag
git push upstream v1.2.0
```

### 8. Automated Release

GitHub Actions will automatically:

1. **Run tests** on all platforms
2. **Build binaries** for:
   - Linux (amd64, arm64, arm)
   - macOS (amd64, arm64)
   - Windows (amd64)
3. **Create archives** (.tar.gz for Unix, .zip for Windows)
4. **Generate checksums**
5. **Build Docker images** and push to registry
6. **Create GitHub release** with:
   - Release notes extracted from CHANGELOG
   - Binary downloads
   - Checksums
   - Docker image references
7. **Update Homebrew tap** (if configured)

### 9. Verify Release

```bash
# Check GitHub releases
gh release view v1.2.0

# Or visit
# https://github.com/fabianopinto/riot/releases/tag/v1.2.0

# Test installation
go install github.com/fabianopinto/riot/cmd/riot@v1.2.0
riot --version

# Test Docker image
docker pull fabianopinto/riot:v1.2.0
docker run --rm fabianopinto/riot:v1.2.0 --version
```

### 10. Announce Release

- Update README.md badges if needed
- Post announcement in GitHub Discussions
- Update project website (if applicable)
- Notify users through appropriate channels

## Hotfix Releases

For critical bugs in production:

### 1. Create Hotfix Branch

```bash
# Branch from the release tag
git checkout -b hotfix/v1.2.1 v1.2.0
```

### 2. Fix the Bug

```bash
# Make the fix
# Add/update tests
# Update CHANGELOG.md

git add .
git commit -m "fix: critical bug in component X"
```

### 3. Create Hotfix PR

```bash
# Push to your fork
git push origin hotfix/v1.2.1

# Create PR to main
gh pr create \
  --base main \
  --title "Hotfix v1.2.1: Critical bug in X" \
  --label "hotfix" \
  --body "## Problem
Critical bug causing [describe impact]

## Solution
[Describe the fix]

## Testing
- [x] Unit tests added
- [x] Manual testing completed
- [x] Verified on affected platforms"
```

### 4. Release Hotfix

After PR is merged and CI passes:

```bash
git checkout main
git pull upstream main

# Create and push tag
git tag -a v1.2.1 -m "Hotfix release v1.2.1

Fix critical bug in component X"

git push upstream v1.2.1
```

## Pre-Release Versions

For testing before official release:

### Alpha Releases (early testing)

```bash
git tag -a v1.3.0-alpha.1 -m "Alpha release for v1.3.0"
git push upstream v1.3.0-alpha.1
```

### Beta Releases (feature complete, testing)

```bash
git tag -a v1.3.0-beta.1 -m "Beta release for v1.3.0"
git push upstream v1.3.0-beta.1
```

### Release Candidates (final testing)

```bash
git tag -a v1.3.0-rc.1 -m "Release candidate 1 for v1.3.0"
git push upstream v1.3.0-rc.1
```

## Release Configuration

### GoReleaser Configuration

The release process is configured in `.goreleaser.yml`:

- **builds**: Defines build matrix (OS, architectures)
- **archives**: Packaging format and included files
- **checksum**: Algorithm for checksums
- **changelog**: Automatic changelog generation
- **release**: GitHub release settings
- **brews**: Homebrew formula generation
- **dockers**: Docker image configuration

### GitHub Actions Workflow

Release workflow (`.github/workflows/release.yml`):

- **Trigger**: On tag push matching `v*.*.*`
- **Steps**:
  1. Checkout code with full history
  2. Set up Go environment
  3. Run tests
  4. Extract release notes from CHANGELOG
  5. Run GoReleaser
  6. Publish release

## Testing Releases

### Local Snapshot Release

Test the release process without publishing:

```bash
# Create snapshot release
make release-snapshot

# Or manually
goreleaser release --snapshot --clean

# Check output in dist/
ls -la dist/
```

### Test Different Platforms

```bash
# Build for specific platform
GOOS=linux GOARCH=amd64 go build -o riot-linux-amd64 ./cmd/riot
GOOS=darwin GOARCH=arm64 go build -o riot-darwin-arm64 ./cmd/riot
GOOS=windows GOARCH=amd64 go build -o riot-windows-amd64.exe ./cmd/riot
```

## Release Artifacts

Each release includes:

### Binary Distributions

- **riot_X.Y.Z_Linux_x86_64.tar.gz**
- **riot_X.Y.Z_Linux_arm64.tar.gz**
- **riot_X.Y.Z_Darwin_x86_64.tar.gz**
- **riot_X.Y.Z_Darwin_arm64.tar.gz**
- **riot_X.Y.Z_Windows_x86_64.zip**

### Additional Files

- **checksums.txt**: SHA256 checksums
- **SBOM files**: Software Bill of Materials
- **Source code**: Automatic GitHub archives

### Docker Images

- `fabianopinto/riot:latest`
- `fabianopinto/riot:v1.2.0`
- `fabianopinto/riot:v1.2`
- `fabianopinto/riot:v1`

## Rollback Process

If a release has critical issues:

### 1. Delete GitHub Release

```bash
gh release delete v1.2.0 --yes
```

### 2. Delete Tag

```bash
git push upstream :refs/tags/v1.2.0
git tag -d v1.2.0
```

### 3. Communicate

- Add notice to GitHub Discussions
- Update documentation
- Recommend users stay on previous version

### 4. Fix and Re-Release

- Fix the issue
- Follow hotfix process
- Release as v1.2.1

## Post-Release Tasks

After each release:

- [ ] Monitor issue tracker for release-related bugs
- [ ] Update project metrics
- [ ] Review and update documentation
- [ ] Plan next release
- [ ] Archive old pre-release versions

## Version Support Policy

- **Latest version**: Full support, all bug fixes
- **Previous minor version**: Security fixes only
- **Older versions**: No support (upgrade recommended)

Example:

- Current: v1.3.0 (full support)
- Previous: v1.2.x (security fixes)
- Old: v1.1.x and earlier (no support)

## Troubleshooting

### Release Workflow Fails

```bash
# Check workflow logs
gh run list
gh run view <run-id>

# Common issues:
# - Tests failing: Fix tests and re-tag
# - GoReleaser config: Test locally first
# - Permissions: Check GITHUB_TOKEN permissions
```

### Missing Release Assets

```bash
# Re-run release workflow
gh workflow run release.yml

# Or manually with GoReleaser
goreleaser release --clean
```

### Tag Already Exists

```bash
# Delete and recreate tag
git tag -d v1.2.0
git push upstream :refs/tags/v1.2.0
git tag -a v1.2.0 -m "Release message"
git push upstream v1.2.0
```

## References

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [GoReleaser Documentation](https://goreleaser.com/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)
