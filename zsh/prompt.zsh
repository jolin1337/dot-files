# heavily inspired by the wonderful pure theme
# https://github.com/sindresorhus/pure

# needed to get things like current git branch
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git # You can add hg too if needed: `git hg`
zstyle ':vcs_info:git*' use-simple true
zstyle ':vcs_info:git*' max-exports 2
zstyle ':vcs_info:git*' formats ' %b' 'x%R'
zstyle ':vcs_info:git*' actionformats ' %b|%a' 'x%R'

autoload colors && colors

PROMPT_SYMBOL='' #'❯'


bg_to_fg_color() {
    local color=$1
    echo ${${color/K/F}/k/f}
}
fg_to_bg_color() {
    local color=$1
    echo ${${color/F/K}/f/k}
}
local FG_BLUE="%F{4}text%f"
local BG_BLUE="`fg_to_bg_color $FG_BLUE`"
local FG_GREEN="%F{green}text%f"
local BG_GREEN="`fg_to_bg_color $FG_GREEN`"
local FG_GREY="%F{red}text%f"
local BG_GREY="`fg_to_bg_color $FG_RED`"
local FG_RED="%F{red}text%f"
local BG_RED="`fg_to_bg_color $FG_RED`"
local FG_WHITE="%F{white}text%f"
local BG_WHITE="`fg_to_bg_color $FG_WHITE`"
local FG_BLACK="%F{black}text%f"
local BG_BLACK="`fg_to_bg_color $FG_BLACK`"


powerline_arrow() {
    local text=$1
    local FG_COLOR=$2
    local BG_COLOR=$3
    local BG_NEXT=${4:-text}
    if (( $# == 1 ));then
        echo -n "$1 $PROMPT_SYMBOL"
    elif (( $# == 2 )); then
        echo -n "${FG_COLOR/text/$text $PROMPT_SYMBOL}"
    else
        local fg_text=${FG_COLOR/text/$text}
        local FG_BG_COLOR=`bg_to_fg_color $BG_COLOR`
        local fg_prompt_symbol=${FG_BG_COLOR/text/$PROMPT_SYMBOL}
        echo -n "%B${BG_COLOR/text/ $fg_text }${BG_NEXT/text/$fg_prompt_symbol}%b"
    fi
}

git_dirty() {
    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return

    # check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null;
    if [[ $? -eq 1 ]]; then
        echo "%F{red}✗%f"
    else
        echo "%F{green}✔%f"
    fi
}

git_additions() {
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    changes=$(git diff --shortstat master | sed -r 's/^ [0-9]+ files changed,|[a-z( ),]+//g') 2>/dev/null
    [[ $changes ]] || return
    additions=$(echo $changes | sed -r 's/([0-9]+)(\+).*/\1/g') 2>/dev/null
    deletions=$(echo $changes | sed "s/$additions+\|-//g") 2>/dev/null
    echo "%F{green}+$additions%f/%F{red}-$deletions%f"
}

upstream_branch() {
    remote=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)) 2>/dev/null
    if [[ $remote != "" ]]; then
        echo "%F{241}($remote)%f"
    fi
}

# get the status of the current branch and it's remote
# If there are changes upstream, display a ⇣
# If there are changes that have been committed but not yet pushed, display a ⇡
git_arrows() {
    # do nothing if there is no upstream configured
    local branch="$( git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null )"
    [ -n "$branch" ] || return  # git branch not found

    local arrows="$branch"

    # how many commits local branch is ahead/behind of remote?
    local status
    local stat="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
    local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    [ -n "$aheadN" ] && arrows+="%F{011}⇣ $aheadN%f"
    [ -n "$behindN" ] && arrows+="%F{011}⇡ $behindN%f"

    echo $arrows
}


# indicate a job (for example, vim) has been backgrounded
# If there is a job in the background, display a ✱
suspended_jobs() {
    local sj
    sj=$(jobs 2>/dev/null | tail -n 1)
    if [[ $sj == "" ]]; then
        echo ""
    else
        echo "%{%F{208}%}✱%f"
    fi
}

# Store elapsed time of previous command
preexec () {
    (( $#_elapsed > 1000 )) && set -A _elapsed $_elapsed[-1000,-1]
    typeset -ig _start=SECONDS
}
precmd () {
    (( _start >= 0 )) && set -A _elapsed $_elapsed $(( SECONDS-_start ))
    _start=-1
}
notification() {
    MINSECTIME=5
    if (( $_elapsed[-1] > $MINSECTIME )); then
        cmd=$(history | tail -n1)
        notify-send "$_elapsed[-1]s to execute $cmd" 2>/dev/null
    fi
}

# precmd() {
#     vcs_info
#     print -P '\n%F{6}%~'
# }

# export PROMPT="%(?.%F{207}.%F{160})%t $PROMPT_SYMBOL%f "
PROGRAMS='$(git_additions)%F{241} $vcs_info_msg_0_%f $(git_arrows) $(suspended_jobs) $(notification)'
error_line="%(?..`powerline_arrow %? $FG_WHITE $BG_RED $BG_BLUE`)"
time_line="`powerline_arrow %T $FG_WHITE $BG_BLUE $BG_BLACK`"
path_line="`powerline_arrow %3d $FG_WHITE $BG_GREEN`"
programs_line="`powerline_arrow "$PROGRAMS" $FG_WHITE $BG_BLACK $BG_GREEN`"
export PROMPT="$error_line$time_line$programs_line$path_line "
# export RPROMPT='$(battery_indicator.sh 2>/dev/null)'
# export RPROMPT='$(git_dirty)%F{241} $vcs_info_msg_0_%f $(git_arrows) $(suspended_jobs)'
