# RIoT

[![Go Report Card](https://goreportcard.com/badge/github.com/fabianopinto/riot)](https://goreportcard.com/report/github.com/fabianopinto/riot)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Go Version](https://img.shields.io/github/go-mod/go-version/fabianopinto/riot)](go.mod)

A Go project built following best practices for open-source development.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Overview

RIoT is [describe your project here].

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

### Prerequisites

- Go 1.25 or higher
- Git

### Using go install

```bash
go install github.com/fabianopinto/riot/cmd/riot@latest
```

### Building from source

```bash
git clone https://github.com/fabianopinto/riot.git
cd riot
make build
```

## Usage

```bash
riot [command] [flags]
```

### Examples

```bash
# Example command
riot help
```

## Development

See [DEVELOPMENT.md](docs/DEVELOPMENT.md) for detailed development instructions.

### Quick Start

```bash
# Clone the repository
git clone https://github.com/fabianopinto/riot.git
cd riot

# Install dependencies
go mod download

# Run tests
make test

# Build
make build

# Run locally
./bin/riot
```

### Project Structure

```
.
├── cmd/                  # Command-line applications
│   └── riot/            # Main application entry point
├── internal/            # Private application code
│   └── app/            # Application logic
├── pkg/                 # Public library code
├── configs/             # Configuration files
├── scripts/             # Build and utility scripts
├── docs/               # Documentation
├── .github/            # GitHub specific files (workflows, templates)
└── Makefile            # Build automation
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- Code of Conduct
- Development workflow
- Pull request process
- Coding standards

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [golang-standards/project-layout](https://github.com/golang-standards/project-layout) for project structure guidance
- Contributors and maintainers

## Support

- **Issues**: [GitHub Issues](https://github.com/fabianopinto/riot/issues)
- **Discussions**: [GitHub Discussions](https://github.com/fabianopinto/riot/discussions)

## Releases

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each release.

This project uses:

- **Conventional Commits** for automated changelog generation
- **Semantic Versioning** for release numbering
- **GoReleaser** for automated release builds

For maintainers, see [docs/RELEASE.md](docs/RELEASE.md) for the release process.
