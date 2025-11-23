# Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.x.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of RIoT seriously. If you have discovered a security vulnerability, please report it privately.

### How to Report

**Do NOT open a public issue.** Instead:

1. **Use GitHub Security Advisories** (Recommended):

   - Go to https://github.com/fabianopinto/riot/security/advisories
   - Click "Report a vulnerability"
   - Fill in the details

2. **Email** (Alternative):
   - Send details to: [INSERT SECURITY EMAIL]
   - Use GPG key [INSERT KEY ID] for encryption if possible

### What to Include

Please provide:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)
- Your contact information

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: 7 days
  - High: 30 days
  - Medium: 90 days
  - Low: Best effort

### Disclosure Policy

- We will coordinate disclosure timing with you
- We will credit you in the security advisory (unless you prefer to remain anonymous)
- We will publish a security advisory after the fix is released

## Security Best Practices

When using RIoT:

### For Users

- Always use the latest version
- Keep dependencies up to date
- Follow the principle of least privilege
- Review security advisories regularly
- Report suspicious behavior

### For Contributors

- Never commit secrets (API keys, passwords, tokens)
- Use `.env` files for local development (gitignored)
- Run security scanners before submitting PRs:
  ```bash
  make lint  # Includes gosec
  ```
- Review dependencies for known vulnerabilities:
  ```bash
  go list -json -m all | nancy sleuth
  ```

## Security Tools

This project uses:

- **gosec**: Security scanner integrated in golangci-lint
- **CodeQL**: GitHub's code analysis tool (runs on every PR)
- **Dependabot**: Automated dependency updates

## Known Security Considerations

### Dependencies

- We use `go mod` for dependency management
- Dependencies are regularly updated via Dependabot
- We review dependency changes before merging

### Build Process

- Builds are reproducible
- Release binaries are signed with checksums
- CI/CD runs in isolated environments

## Security Updates

Security updates are announced:

1. GitHub Security Advisories
2. Release notes in CHANGELOG.md
3. GitHub Discussions

## Acknowledgments

We appreciate responsible disclosure and will acknowledge security researchers who report vulnerabilities (with their permission).

## Questions?

For general security questions (not vulnerability reports), you can:

- Open a GitHub Discussion
- Contact the maintainers

Thank you for helping keep RIoT secure!
