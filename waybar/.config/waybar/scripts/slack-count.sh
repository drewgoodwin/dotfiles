#!/bin/bash

# Get Slack window title from Hyprland
slack_title=$(hyprctl clients -j | jq -r '.[] | select(.class == "com.slack.Slack") | .title' 2>/dev/null)

# Exit if Slack is not running
if [ -z "$slack_title" ]; then
    echo '{"text": "", "tooltip": "Slack not running", "class": "offline"}'
    exit 0
fi

# Parse notification count from title
# Slack shows notifications as "(X)" at the start of title or in various formats
# Examples: "(5) channel - workspace - Slack", "channel - workspace - Slack • 5"
count=0

# Check for pattern like "(5) channel - workspace - Slack"
if [[ $slack_title =~ ^\(([0-9]+)\) ]]; then
    count="${BASH_REMATCH[1]}"
# Check for pattern like "workspace - Slack • 5"  
elif [[ $slack_title =~ •[[:space:]]*([0-9]+) ]]; then
    count="${BASH_REMATCH[1]}"
# Check for pattern with bullet at end like "Slack 🎤 (5)"
elif [[ $slack_title =~ \(([0-9]+)\)[[:space:]]*$ ]]; then
    count="${BASH_REMATCH[1]}"
# Check for pattern like "channel - workspace - 5 new items - Slack" or "- 1 new item -"
elif [[ $slack_title =~ ([0-9]+)[[:space:]]+new[[:space:]]+items? ]]; then
    count="${BASH_REMATCH[1]}"
fi

# Format output for waybar
if [ "$count" -gt 0 ]; then
    echo "{\"text\": \" $count\", \"tooltip\": \"$count unread Slack messages\", \"class\": \"has-notifications\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"No unread Slack messages\", \"class\": \"no-notifications\"}"
fi
