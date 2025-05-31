#!/bin/bash

# Script to download diagnostic logs from GitHub Actions

# Configuration
REPO_OWNER="Split1700"
REPO_NAME="conkyluanv-autoscale-fixed"
OUTPUT_DIR="github_errors"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo "Please install it from https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated with GitHub
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You need to authenticate with GitHub:${NC}"
    gh auth login
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Get latest workflow runs
echo -e "${GREEN}Fetching recent workflow runs...${NC}"
gh run list --repo "$REPO_OWNER/$REPO_NAME" --limit 10

# Ask for the run ID
echo -e "${YELLOW}Enter the Run ID of the failed workflow (or 'latest' to download from the most recent failed run):${NC}"
read RUN_ID

if [ "$RUN_ID" = "latest" ]; then
    echo -e "${GREEN}Finding the latest failed run...${NC}"
    RUN_ID=$(gh run list --repo "$REPO_OWNER/$REPO_NAME" --status failure --limit 1 --json databaseId --jq '.[0].databaseId')
    
    if [ -z "$RUN_ID" ]; then
        echo -e "${RED}No failed runs found.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Found run ID: $RUN_ID${NC}"
fi

# Create a directory for this run
RUN_DIR="$OUTPUT_DIR/logs_$RUN_ID"
mkdir -p "$RUN_DIR"

# Download artifacts
echo -e "${GREEN}Downloading artifacts for run $RUN_ID...${NC}"
gh run download "$RUN_ID" --repo "$REPO_OWNER/$REPO_NAME" --dir "$RUN_DIR"

# Check if artifacts were downloaded
if [ "$(ls -A "$RUN_DIR")" ]; then
    echo -e "${GREEN}Successfully downloaded diagnostic logs to $RUN_DIR${NC}"
    echo -e "${YELLOW}Summary of diagnostics:${NC}"
    
    # Display summary.txt if it exists
    if [ -f "$RUN_DIR/summary.txt" ]; then
        cat "$RUN_DIR/summary.txt"
    elif [ -f "$RUN_DIR/diagnostic-logs/summary.txt" ]; then
        cat "$RUN_DIR/diagnostic-logs/summary.txt"
    elif [ -f "$RUN_DIR/web-diagnostic-logs/summary.txt" ]; then
        cat "$RUN_DIR/web-diagnostic-logs/summary.txt"
    else
        echo -e "${YELLOW}No summary file found. Please check the logs manually.${NC}"
        ls -la "$RUN_DIR"
    fi
else
    echo -e "${RED}No artifacts found for run $RUN_ID.${NC}"
    echo -e "${YELLOW}Downloading workflow logs instead...${NC}"
    
    # Download workflow logs
    gh run view "$RUN_ID" --repo "$REPO_OWNER/$REPO_NAME" --log > "$RUN_DIR/workflow.log"
    echo -e "${GREEN}Workflow logs saved to $RUN_DIR/workflow.log${NC}"
fi

echo -e "${GREEN}Done! You can now analyze the logs and share them for assistance.${NC}" 