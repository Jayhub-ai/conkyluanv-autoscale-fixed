# Contributing to Conky

Thank you for your interest in contributing to this modified version of Conky! This guide will help you get started with the development process.

## Reporting Build Issues

If you encounter issues with building or running Conky, follow these steps:

### Automated Diagnostic Workflows

This repository has automated diagnostic workflows that provide detailed error information when builds fail. To use them:

1. Go to the [Actions tab](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions) in the GitHub repository
2. Select the "Build Diagnostics" or "Web Diagnostics" workflow
3. Click "Run workflow" (dropdown on the right)
4. Use the default branch or select your feature branch
5. Wait for the workflow to complete
6. If the workflow fails, you can download the diagnostic logs (see below)

### Downloading Diagnostic Logs

We've provided a helper script to easily download diagnostic logs from GitHub:

1. Install the GitHub CLI (`gh`) from https://cli.github.com/
2. Authenticate with GitHub: `gh auth login`
3. Run the helper script: `./download_diagnostics.sh`
4. When prompted, enter the Run ID of the failed workflow or type "latest"
5. The script will download all diagnostic logs to the `github_errors` directory

### Sharing Logs for Help

When seeking help with build issues:

1. Run the diagnostic workflow as described above
2. Download the logs using the helper script
3. Share the logs in your issue or discussion post
4. Clearly describe what you were trying to do when the error occurred

## Development Workflow

1. Fork the repository on GitHub
2. Clone your fork locally
3. Create a new branch for your feature or bugfix
4. Make your changes
5. Run the diagnostic workflows to ensure everything builds correctly
6. Submit a pull request

## Build Tips

### Prerequisites

To build Conky from source, you'll need the following dependencies:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential cmake libx11-dev libxdamage-dev libxft-dev libxinerama-dev libxml2-dev libxext-dev libcurl4-openssl-dev liblua5.3-dev libcairo2-dev libimlib2-dev libxnvctrl-dev

# Arch Linux
sudo pacman -S base-devel cmake libx11 libxdamage libxft libxinerama libxml2 libxext curl lua cairo imlib2 nvidia-utils
```

### Building

```bash
mkdir build
cd build
cmake .. -DBUILD_NVIDIA=ON -DBUILD_LUA_CAIRO=ON -DBUILD_LUA_IMLIB2=ON
make
```

## Web Development

For the web documentation site:

```bash
cd web
npm ci
npm run dev
```

## Code Style

- Follow the existing code style in the files you're modifying
- Use descriptive variable and function names
- Add comments for non-obvious code sections
- Keep line length reasonable (around 80-100 characters)

## Testing

Run tests with:

```bash
cd build
ctest --output-on-failure
```

Thank you for contributing! 