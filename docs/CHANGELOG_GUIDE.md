# Changelog Management Guide

This guide explains how to manage the CHANGELOG.md file in this project.

## Overview

This project uses **automated changelog generation** based on git commit history. The changelog is generated from commit messages that follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Tools

- **git-chglog**: Generates CHANGELOG.md from git history
- **Conventional Commits**: Commit message format for structured changelogs

## Installation

Development tools (including git-chglog) are installed automatically:

```bash
make tools
```

## Usage

### Preview Changes for Next Release

See what will be in the changelog for the next release:

```bash
make changelog-next
```

This shows all changes since the last tag.

### Generate Full Changelog

Regenerate the entire CHANGELOG.md from git history:

```bash
make changelog
```

This overwrites CHANGELOG.md with content generated from all git tags and commits.

### Prepare a Release

Interactive release preparation that updates the changelog with a specific version:

```bash
make release-prepare
```

This will:

1. Prompt you for a version number (e.g., v1.0.0)
2. Generate changelog entries for that version
3. Update CHANGELOG.md
4. Show next steps for completing the release

## Commit Message Format

For the changelog to be generated correctly, use this commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type       | Description             | Appears in Changelog |
| ---------- | ----------------------- | -------------------- |
| `feat`     | New feature             | ✅ Features          |
| `fix`      | Bug fix                 | ✅ Bug Fixes         |
| `perf`     | Performance improvement | ✅ Performance       |
| `refactor` | Code refactoring        | ✅ Code Refactoring  |
| `docs`     | Documentation           | ✅ Documentation     |
| `test`     | Tests                   | ✅ Tests             |
| `style`    | Code style/formatting   | ✅ Styles            |
| `chore`    | Maintenance             | ✅ Chores            |
| `ci`       | CI/CD changes           | ✅ CI/CD             |
| `build`    | Build system            | ✅ Build System      |

### Examples

**Simple commit:**

```bash
git commit -m "feat: add user authentication"
```

**With scope:**

```bash
git commit -m "feat(api): add REST endpoint for user management"
```

**With body:**

```bash
git commit -m "fix: resolve memory leak in parser

The parser was not properly releasing memory after processing
large files. This fix ensures proper cleanup."
```

**Breaking change:**

```bash
git commit -m "feat: redesign API structure

BREAKING CHANGE: API endpoints have been restructured.
Update your client code to use the new endpoint paths."
```

## Workflow

### During Development

1. Make your changes
2. Commit using conventional commit format:
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```
3. Push to your branch
4. Create PR

### Before Release

1. **Preview changes:**

   ```bash
   make changelog-next
   ```

2. **Prepare release:**

   ```bash
   make release-prepare
   # Enter version when prompted: v1.0.0
   ```

3. **Review CHANGELOG.md:**

   - Check that all changes are listed
   - Verify formatting
   - Add any manual notes if needed

4. **Commit and tag:**

   ```bash
   git add CHANGELOG.md
   git commit -m "chore: prepare v1.0.0 release"
   git push origin main

   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

5. **Automated release:**
   - GitHub Actions will automatically create the release
   - Binaries will be built for all platforms
   - Release notes will be extracted from CHANGELOG.md

## Configuration

### git-chglog Configuration

Configuration files are in `.chglog/`:

- **config.yml**: Main configuration

  - Commit filters (which types to include)
  - Commit group titles
  - Header pattern for parsing commits

- **CHANGELOG.tpl.md**: Template for generating CHANGELOG.md
  - Markdown formatting
  - Section structure
  - Link generation

### Customization

To modify which commit types appear in the changelog, edit `.chglog/config.yml`:

```yaml
options:
  commits:
    filters:
      Type:
        - feat
        - fix
        # Add or remove types here
```

To change section titles, edit the `title_maps`:

```yaml
commit_groups:
  title_maps:
    feat: Features
    fix: Bug Fixes
    # Customize titles here
```

## Manual Changelog Entries

If you need to add manual entries (not from commits):

1. Generate the changelog:

   ```bash
   make changelog
   ```

2. Edit CHANGELOG.md and add your manual entries

3. Commit:
   ```bash
   git add CHANGELOG.md
   git commit -m "docs: update changelog with manual entries"
   ```

**Note:** Manual entries will be preserved on the next generation if they're in the "Unreleased" section.

## Best Practices

### DO ✅

- Use conventional commit format consistently
- Write clear, descriptive commit messages
- Use scopes to organize related changes
- Mark breaking changes explicitly
- Preview changelog before release
- Review generated changelog for accuracy

### DON'T ❌

- Mix multiple types in one commit
- Use vague commit messages ("fix stuff", "update")
- Forget to mark breaking changes
- Skip the changelog preview step
- Manually edit old release sections

## Troubleshooting

### Changelog is empty or missing commits

**Problem:** Some commits don't appear in the changelog.

**Solution:** Check that commits use conventional format:

```bash
# View recent commits
git log --oneline -20

# Check commit format
git log --format="%s" -20
```

### Wrong version in changelog

**Problem:** Changelog shows incorrect version number.

**Solution:** Use `make release-prepare` and enter the correct version when prompted.

### Breaking changes not highlighted

**Problem:** Breaking changes don't appear in a special section.

**Solution:** Ensure commit includes `BREAKING CHANGE:` in the footer:

```bash
git commit -m "feat: new API

BREAKING CHANGE: Old API endpoints removed"
```

### Manual edits get overwritten

**Problem:** Manual changelog edits are lost when regenerating.

**Solution:**

- Only edit the "Unreleased" section
- Or add manual notes after running `make changelog`
- Consider using commit messages instead of manual edits

## Examples

### Feature Release (v1.1.0)

```bash
# Development commits
git commit -m "feat: add user profiles"
git commit -m "feat: add avatar upload"
git commit -m "fix: profile validation"

# Prepare release
make release-prepare
# Enter: v1.1.0

# Review and commit
git add CHANGELOG.md
git commit -m "chore: prepare v1.1.0 release"
git push origin main

# Tag and release
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

### Hotfix Release (v1.0.1)

```bash
# Fix critical bug
git commit -m "fix: resolve security vulnerability in auth"

# Prepare hotfix
make release-prepare
# Enter: v1.0.1

# Fast-track release
git add CHANGELOG.md
git commit -m "chore: prepare v1.0.1 hotfix"
git push origin main

git tag -a v1.0.1 -m "Hotfix v1.0.1"
git push origin v1.0.1
```

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [git-chglog Documentation](https://github.com/git-chglog/git-chglog)
- [Project Release Guide](RELEASE.md)
