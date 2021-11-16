# ------------------------------------------------------------------------------
# Description
# -----------
#
# plugin based on official sudo plugin
# watch will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Enrico Falco <enrico9034@gmail.com>
#
# ------------------------------------------------------------------------------

watch-command-line() {
    [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

    # Save beginning space
    local WHITESPACE=""
    if [[ ${LBUFFER:0:1} == " " ]] ; then 
        WHITESPACE=" "
        LBUFFER="${LBUFFER:1}"
    fi

    # Expand aliases
    unset 'functions[_watch-plugin-expand]' # Clear function set by previous call
    functions[_watch-plugin-expand]=${LBUFFER} # Save LBUFFER to functions file, this will expand the aliases
    (($+functions[_watch-plugin-expand])) && LBUFFER=${functions[_watch-plugin-expand]#$'\t'} # Get the (expanded) function content back and clear the first tab(s)

    if [[ $BUFFER == watch\ * ]]; then
        if [[ ${#LBUFFER} -le 5 ]]; then
            RBUFFER="${BUFFER#watch }"
            LBUFFER=""
        else
            LBUFFER="${LBUFFER#watch }"
        fi
    else
        LBUFFER="watch $LBUFFER"
    fi

    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"
}
zle -N watch-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '^W' watch-command-line
bindkey -M vicmd '^W' watch-command-line
bindkey -M viins '^W' watch-command-line
