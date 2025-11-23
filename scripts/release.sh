#!/bin/bash

# Release Helper Script for RIoT
# This script helps create releases following best practices

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if we're on main branch
check_branch() {
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$CURRENT_BRANCH" != "main" ]; then
        log_error "Not on main branch. Currently on: $CURRENT_BRANCH"
        log_info "Switch to main: git checkout main"
        exit 1
    fi
}

# Check for uncommitted changes
check_clean_working_tree() {
    if ! git diff-index --quiet HEAD --; then
        log_error "Working tree is not clean. Commit or stash changes first."
        git status
        exit 1
    fi
}

# Validate version format
validate_version() {
    local version=$1
    if ! [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_error "Invalid version format: $version"
        log_info "Expected format: X.Y.Z (e.g., 1.2.3)"
        exit 1
    fi
}

# Check if tag already exists
check_tag_exists() {
    local version=$1
    if git rev-parse "v$version" >/dev/null 2>&1; then
        log_error "Tag v$version already exists"
        log_info "Use a different version or delete the existing tag:"
        log_info "  git tag -d v$version"
        log_info "  git push origin :refs/tags/v$version"
        exit 1
    fi
}

# Update CHANGELOG
update_changelog() {
    local version=$1
    local date=$(date +%Y-%m-%d)

    log_step "Updating CHANGELOG.md..."

    if ! grep -q "## \[Unreleased\]" CHANGELOG.md; then
        log_error "CHANGELOG.md doesn't have [Unreleased] section"
        exit 1
    fi

    # Create backup
    cp CHANGELOG.md CHANGELOG.md.bak

    # Update CHANGELOG
    sed -i.tmp "s/## \[Unreleased\]/## [Unreleased]\n\n## [$version] - $date/" CHANGELOG.md
    rm CHANGELOG.md.tmp

    log_info "CHANGELOG.md updated"
    log_info "Please review the changes in CHANGELOG.md"

    # Show diff
    git diff CHANGELOG.md

    echo
    read -p "Does this look correct? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Restoring CHANGELOG.md..."
        mv CHANGELOG.md.bak CHANGELOG.md
        log_error "Release cancelled"
        exit 1
    fi

    rm CHANGELOG.md.bak
}

# Create release
create_release() {
    local version=$1

    log_step "Creating release v$version..."

    # Commit changelog
    git add CHANGELOG.md
    git commit -m "chore: prepare release v$version"

    # Create tag
    log_info "Creating annotated tag..."
    git tag -a "v$version" -m "Release version $version"

    log_info "Release prepared locally"
    log_warn "Review the commit and tag before pushing:"
    log_info "  git log -1"
    log_info "  git show v$version"

    echo
    read -p "Push release to upstream? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Push commit and tag
        log_info "Pushing to upstream..."
        git push upstream main
        git push upstream "v$version"

        log_info ""
        log_info "✅ Release v$version created successfully!"
        log_info ""
        log_info "GitHub Actions will now:"
        log_info "  - Run all tests"
        log_info "  - Build binaries for all platforms"
        log_info "  - Create GitHub release"
        log_info "  - Build and push Docker images"
        log_info ""
        log_info "Monitor the release workflow:"
        log_info "  https://github.com/fabianopinto/riot/actions"
        log_info ""
        log_info "Or use: gh run watch"
    else
        log_info "Release not pushed. To push later, run:"
        log_info "  git push upstream main"
        log_info "  git push upstream v$version"
    fi
}

# Show help
show_help() {
    cat << EOF
Usage: $0 [VERSION]

Create a new release for RIoT.

Arguments:
  VERSION    Version number in format X.Y.Z (e.g., 1.2.3)

Examples:
  $0 1.2.3   # Create release v1.2.3

The script will:
  1. Check you're on main branch
  2. Verify working tree is clean
  3. Validate version format
  4. Update CHANGELOG.md
  5. Create commit and tag
  6. Optionally push to upstream

EOF
}

# Main
main() {
    if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        show_help
        exit 0
    fi

    local version=$1

    log_info "Preparing release v$version..."

    # Pre-flight checks
    check_branch
    check_clean_working_tree
    validate_version "$version"
    check_tag_exists "$version"

    # Ensure we're up to date
    log_step "Fetching latest changes..."
    git fetch upstream

    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse upstream/main)

    if [ "$LOCAL" != "$REMOTE" ]; then
        log_error "Local branch is not up to date with upstream/main"
        log_info "Run: git pull upstream main"
        exit 1
    fi

    # Run tests
    log_step "Running tests..."
    if ! make test; then
        log_error "Tests failed. Fix tests before releasing."
        exit 1
    fi

    # Update changelog and create release
    update_changelog "$version"
    create_release "$version"
}

main "$@"
