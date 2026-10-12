# Verify external prerequisites before doing anything destructive.
function __ft_preflight --description 'Preflight checks for git-forktail'
    if not command -q gh
        __ft_log err "gh CLI not found in PATH"
        return 1
    end
    if not command -q git
        __ft_log err "git not found in PATH"
        return 1
    end
    if not gh auth status >/dev/null 2>&1
        __ft_log err "gh is not authenticated — run: gh auth login"
        return 1
    end
    if not set -q SSH_AUTH_SOCK
        __ft_log warn "SSH_AUTH_SOCK not set — git-over-ssh may fail"
    end
    return 0
end
