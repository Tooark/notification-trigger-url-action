#!/bin/bash
STATUS="$1"
MESSAGE="$2"
PROJECT="$3"
BRANCH="$4"
REPOSITORY="$5"
COMMIT="$6"
CLOUD_PROVIDER="$7"
USER="$8"
BUILD_URL="$9"
CRITICAL_COUNT="${10}"
HIGH_COUNT="${11}"
MEDIUM_COUNT="${12}"
LOW_COUNT="${13}"
UNKNOWN_COUNT="${14}"
TOTAL_COUNT="${15}"
WEBHOOK_URL="${16}"

echo "DEBUG (Notification Script): STATUS=$STATUS"
echo "DEBUG (Notification Script): TOTAL_COUNT=$TOTAL_COUNT"

VULNERABILITY_STATUS_STRING="false"
if [ "$TOTAL_COUNT" -gt 0 ]; then
  VULNERABILITY_STATUS_STRING="true"
fi

BASE_PAYLOAD=$(jq -n \
  --arg status "$STATUS" \
  --arg message "$MESSAGE" \
  --arg project "$PROJECT" \
  --arg branch "$BRANCH" \
  --arg repository "$REPOSITORY" \
  --arg commit "$COMMIT" \
  --arg cloud_provider "$CLOUD_PROVIDER" \
  --arg user "$USER" \
  --arg build_url "$BUILD_URL" \
  --arg vulnerability_status_str "$VULNERABILITY_STATUS_STRING" \
  '{
    "status": $status,
    "message": $message,
    "project": $project,
    "branch": $branch,
    "repository": $repository,
    "commit": $commit,
    "cloud_provider": $cloud_provider,
    "user": $user,
    "build_url": $build_url,
    "vulnerability_present": $vulnerability_status_str
  }')

if [ "$TOTAL_COUNT" -gt 0 ]; then
  VULNERABILITY_DATA=$(jq -n \
    --argjson critical "$CRITICAL_COUNT" \
    --argjson high "$HIGH_COUNT" \
    --argjson medium "$MEDIUM_COUNT" \
    --argjson low "$LOW_COUNT" \
    --argjson unknown "$UNKNOWN_COUNT" \
    --argjson total "$TOTAL_COUNT" \
    '{
      "critical": $critical,
      "high": $high,
      "medium": $medium,
      "low": $low,
      "unknown": $unknown,
      "total": $total
    }')
  
  FINAL_PAYLOAD=$(echo "$BASE_PAYLOAD" | jq --argjson vuln_data "$VULNERABILITY_DATA" '. + {vulnerability: $vuln_data}')
else
  FINAL_PAYLOAD="$BASE_PAYLOAD"
fi

echo "Payload Final Enviado:"
echo "$FINAL_PAYLOAD"

curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$FINAL_PAYLOAD"
