#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
tokens=$(echo "$input" | jq -r '.context_window.current_usage')
used=$(echo "$input" | jq -r '.context_window.used_percentage')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage')

# Parse token usage, filtering out null values properly
input_tokens=$(echo "$tokens" | jq -r 'if .input_tokens == null then empty else .input_tokens end')
output_tokens=$(echo "$tokens" | jq -r 'if .output_tokens == null then empty else .output_tokens end')
cache_creation=$(echo "$tokens" | jq -r 'if .cache_creation_input_tokens == null then empty else .cache_creation_input_tokens end')
cache_read=$(echo "$tokens" | jq -r 'if .cache_read_input_tokens == null then empty else .cache_read_input_tokens end')

# Color codes (combined with dim for readability)
# Cyan for model, Yellow for tokens, Magenta for cache, Green for context
CYAN="\033[2;36m"
YELLOW="\033[2;33m"
MAGENTA="\033[2;35m"
GREEN="\033[2;32m"
RESET="\033[0m"

# Build output part by part
output="${CYAN}$model${RESET}"

if [ -n "$input_tokens" ] && [ "$input_tokens" != "null" ]; then
    output="$output ${YELLOW}In: $input_tokens Out: $output_tokens${RESET}"
    [ -n "$cache_creation" ] && [ "$cache_creation" != "null" ] && output="$output ${MAGENTA}Cache: $cache_creation${RESET}"
fi

if [ -n "$remaining" ] && [ "$remaining" != "null" ]; then
    output="$output ${GREEN}Ctx: ${used}% used, ${remaining}% free${RESET}"
fi

echo -e "$output"
