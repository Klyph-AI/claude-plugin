#!/usr/bin/env bash
# Upload a local video file to a Klyph signed upload URL.
# Usage: klyph-upload.sh <file> <signed_url>
# Exits 0 on a 2xx response, non-zero with a message otherwise.
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: klyph-upload.sh <file> <signed_url>" >&2
  exit 2
fi

file="$1"
url="$2"

if [ ! -f "$file" ]; then
  echo "klyph-upload: file not found: $file" >&2
  exit 1
fi

# Authority (host part) must not contain userinfo ("@"). Signed upload URLs never do.
https_re='^https://[^/?#@]+([/?#]|$)'
loopback_re='^http://(localhost|127\.0\.0\.1)(:[0-9]+)?([/?#]|$)'
if ! [[ "$url" =~ $https_re || "$url" =~ $loopback_re ]]; then
  echo "klyph-upload: the upload URL must be https (or http on localhost), with no user info" >&2
  exit 1
fi

mime="$(file --brief --mime-type -- "$file")"

# The signed URL already carries its token. A raw-body PUT with the right
# Content-Type is what Supabase storage expects.
if ! curl --fail --show-error --progress-bar \
  -X PUT \
  -H "Content-Type: ${mime}" \
  --upload-file "$file" \
  "$url" >/dev/null; then
  echo "klyph-upload: upload failed. The signed URL expires after two hours, so ask for a fresh one if it has been a while." >&2
  exit 1
fi

echo "Upload finished."
