#!/bin/bash
set -e

# XCFramework download script for authenticated GitHub releases
# Usage: ./download-xcframework.sh <repo> <version> <github_token> [output_dir]

REPO="$1"
VERSION="$2"
GITHUB_TOKEN="$3"
OUTPUT_DIR="${4:-./}"

if [ -z "$REPO" ] || [ -z "$VERSION" ] || [ -z "$GITHUB_TOKEN" ]; then
  echo "Usage: $0 <repo> <version> <github_token> [output_dir]"
  echo "Example: $0 CardScan-ai/swift-package-source 3.0.15 \$GITHUB_TOKEN ./frameworks/"
  exit 1
fi

echo "🔍 Downloading XCFramework from $REPO version $VERSION..."

# Ensure version has 'v' prefix for tag
if [[ ! "$VERSION" =~ ^v ]]; then
  TAG="v$VERSION"
else
  TAG="$VERSION"
fi

echo "Repository: $REPO"
echo "Tag: $TAG"
echo "Output directory: $OUTPUT_DIR"

# Get release information
RELEASE_INFO=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$REPO/releases/tags/$TAG")

# Validate API response
if [ -z "$RELEASE_INFO" ] || [ "$RELEASE_INFO" = "null" ]; then
  echo "❌ Error: Empty or null response from GitHub API"
  exit 1
fi

# Check if response contains error
if echo "$RELEASE_INFO" | jq -r '.message' 2>/dev/null | grep -q "Not Found"; then
  echo "❌ Error: Release $TAG not found in repository $REPO"
  exit 1
fi

# Find XCFramework asset
XCFRAMEWORK_ASSET=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | test(".*\\.xcframework\\.zip$")) | .id' | head -1)

if [ -z "$XCFRAMEWORK_ASSET" ] || [ "$XCFRAMEWORK_ASSET" = "null" ]; then
  echo "❌ Error: Could not find XCFramework asset in release $TAG"
  echo "Available assets:"
  echo "$RELEASE_INFO" | jq -r '.assets[].name' || echo "None"
  exit 1
fi

# Validate asset ID is numeric
if ! [[ "$XCFRAMEWORK_ASSET" =~ ^[0-9]+$ ]]; then
  echo "❌ Error: Invalid asset ID: $XCFRAMEWORK_ASSET"
  exit 1
fi

DOWNLOAD_URL="https://api.github.com/repos/$REPO/releases/assets/$XCFRAMEWORK_ASSET"
FILENAME="InsuranceCardScan.xcframework.zip"

echo "Asset ID: $XCFRAMEWORK_ASSET"
echo "Download URL: $DOWNLOAD_URL"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Download using GitHub API asset endpoint with authentication
echo "⬇️  Downloading XCFramework..."
if ! curl -L --max-filesize 104857600 --connect-timeout 30 --max-time 600 \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/octet-stream" \
  -o "$OUTPUT_DIR/$FILENAME" \
  "$DOWNLOAD_URL"; then
  echo "❌ Error: Failed to download XCFramework"
  exit 1
fi

# Verify download was successful and has reasonable size
if [ ! -f "$OUTPUT_DIR/$FILENAME" ] || [ ! -s "$OUTPUT_DIR/$FILENAME" ]; then
  echo "❌ Error: Downloaded file is missing or empty"
  exit 1
fi

# Check file size is reasonable (between 1MB and 100MB)
DOWNLOAD_SIZE=$(stat -f%z "$OUTPUT_DIR/$FILENAME" 2>/dev/null || stat -c%s "$OUTPUT_DIR/$FILENAME" 2>/dev/null || echo 0)
if [ "$DOWNLOAD_SIZE" -lt 1048576 ] || [ "$DOWNLOAD_SIZE" -gt 104857600 ]; then
  echo "❌ Error: Downloaded file has suspicious size: $DOWNLOAD_SIZE bytes"
  exit 1
fi

echo "✅ Successfully downloaded XCFramework: $(du -h "$OUTPUT_DIR/$FILENAME" | cut -f1)"
echo "📁 File saved to: $OUTPUT_DIR/$FILENAME"