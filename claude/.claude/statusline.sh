#!/usr/bin/env bash
# Claude Code statusline styled after ~/.config/starship.toml (gruvbox_dark, powerline segments)

input=$(cat)

# --- gruvbox_dark palette ---
FG0="251;241;199"   # color_fg0
BG1="60;56;54"      # color_bg1
BG3="102;92;84"     # color_bg3
BLUE="69;133;136"   # color_blue
AQUA="104;157;106"  # color_aqua
ORANGE="214;93;14"  # color_orange
YELLOW="215;153;33" # color_yellow
RED="204;36;29"     # color_red
GREEN="152;151;26"  # color_green

fg() { printf '\033[38;2;%sm' "$1"; }
bg() { printf '\033[48;2;%sm' "$1"; }
reset() { printf '\033[0m'; }
ARROW=$''
ROUND_START=$''
ROUND_END=$''

# segment fg=$1, bg=$2, content=$3
seg() { fg "$1"; bg "$2"; printf ' %s ' "$3"; }
# arrow from segment bg=$1 to next segment bg=$2 (or "" for terminal default)
arrow_to() {
  fg "$1"
  if [ -n "$2" ]; then bg "$2"; else printf '\033[49m'; fi
  printf '%s' "$ARROW"
}
# rounded cap on transparent background, colored to match the segment it touches
cap_start() { fg "$1"; printf '\033[49m%s' "$ROUND_START"; }
cap_end() { fg "$1"; printf '\033[49m%s' "$ROUND_END"; }

# --- parse input ---
model=$(jq -r '.model.display_name // "Claude"' <<<"$input")
cwd=$(jq -r '.workspace.current_dir // .cwd // "."' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
ctx_pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
effort=$(jq -r '.effort.level // empty' <<<"$input")

# --- os icon ---
os_icon="󰌽"
if [ -r /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    arch) os_icon="󰣇" ;;
    ubuntu) os_icon="󰕈" ;;
    debian) os_icon="󰣚" ;;
    fedora) os_icon="󰣛" ;;
    manjaro) os_icon="" ;;
  esac
fi

user=$(whoami)
host=$(hostname -s 2>/dev/null || uname -n 2>/dev/null || cat /proc/sys/kernel/hostname 2>/dev/null)
host="${host%%.*}"

# --- directory (truncate to last 3 components, like starship) ---
dir_display="${cwd/#$HOME/\~}"
dir_display=$(awk -v p="$dir_display" -v n=3 'BEGIN{
  c = split(p, a, "/")
  m = 0
  for (i = 1; i <= c; i++) if (a[i] != "") { m++; b[m] = a[i] }
  if (m <= n) {
    res = ""
    for (i = 1; i <= m; i++) res = res "/" b[i]
    if (substr(p, 1, 1) != "/") sub(/^\//, "", res)
    print res
  } else {
    res = "…"
    for (i = m - n + 1; i <= m; i++) res = res "/" b[i]
    print res
  }
}')

# --- git branch/status (own segment) ---
git_content=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  dirty=""
  [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ] && dirty=" ✗"
  [ -n "$branch" ] && git_content="  ${branch}${dirty}"
fi

# --- model segment content ---
model_content=" ${model}"
[ -n "$effort" ] && [ "$effort" != "null" ] && model_content="${model_content} (${effort})"

# --- context usage gauge, color-coded ---
ctx_color="$GREEN"
ctx_content=""
if [ -n "$ctx_pct" ] && [ "$ctx_pct" != "null" ]; then
  pct_int=${ctx_pct%.*}
  if [ "$pct_int" -ge 80 ] 2>/dev/null; then ctx_color="$RED"
  elif [ "$pct_int" -ge 50 ] 2>/dev/null; then ctx_color="$YELLOW"
  else ctx_color="$GREEN"
  fi
  ctx_content=" ${pct_int}% ctx"
fi

cost_fmt=$(printf '%.4f' "$cost" 2>/dev/null || echo "0.0000")
time_now=$(date +%R)

# --- render ---
cap_start "$ORANGE"
seg "$FG0" "$ORANGE" "${os_icon} ${user}@${host}"
arrow_to "$ORANGE" "$YELLOW"
seg "$FG0" "$YELLOW" " ${dir_display}"
prev_color="$YELLOW"
if [ -n "$git_content" ]; then
  arrow_to "$prev_color" "$AQUA"
  seg "$FG0" "$AQUA" "${git_content}"
  prev_color="$AQUA"
fi
arrow_to "$prev_color" "$BLUE"
seg "$FG0" "$BLUE" "${model_content}"
prev_color="$BLUE"
if [ -n "$ctx_content" ]; then
  arrow_to "$prev_color" "$ctx_color"
  seg "$FG0" "$ctx_color" "${ctx_content}"
  prev_color="$ctx_color"
fi
arrow_to "$prev_color" "$BG3"
seg "$FG0" "$BG3" " \$${cost_fmt}"
arrow_to "$BG3" "$BG1"
seg "$FG0" "$BG1" "  ${time_now}"
cap_end "$BG1"
reset
