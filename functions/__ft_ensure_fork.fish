# Idempotent: ensure the fork exists on GitHub.
#   $argv[1] source slug
#   $argv[2] dest slug
#   $argv[3] optional --fork-name value
#   $argv[4] "true"|"false" dry-run flag

function __ft_ensure_fork --description 'Ensure fork exists on GitHub'
    set -l source_slug $argv[1]
    set -l dest_slug   $argv[2]
    set -l fork_name   $argv[3]
    set -l dry         $argv[4]

    if gh repo view $dest_slug >/dev/null 2>&1
        __ft_log ok "fork already exists: "(__ft_c --bold)"$dest_slug"(__ft_c normal)
        return 0
    end

    __ft_log step "forking "(__ft_c cyan)"$source_slug"(__ft_c normal)" → "(__ft_c cyan)"$dest_slug"(__ft_c normal)

    if test "$dry" = true
        __ft_log vlog "(dry-run) gh repo fork $source_slug --clone=false --remote=false"
        return 0
    end

    set -l cmd gh repo fork $source_slug --clone=false --remote=false
    if test -n "$fork_name"
        set -a cmd --fork-name $fork_name
    end

    $cmd
    or begin
        __ft_log err "gh repo fork failed"
        return 1
    end
    __ft_log ok "created fork $dest_slug"
    return 0
end
