# Idempotent: push current branch to origin.
#   $argv[1] repo directory
#   $argv[2] "true"|"false" dry-run flag

function __ft_push_fork --description 'Push current branch to origin'
    set -l repo_dir $argv[1]
    set -l dry      $argv[2]

    set -l branch (git -C "$repo_dir" symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        __ft_log warn "detached HEAD — skipping push"
        return 0
    end

    __ft_log step "pushing "(__ft_c cyan)"$branch"(__ft_c normal)" → $FT_ORIGIN_REMOTE"
    if test "$dry" = true
        __ft_log vlog "(dry-run) git -C $repo_dir push -u $FT_ORIGIN_REMOTE $branch"
        return 0
    end

    git -C "$repo_dir" push -u $FT_ORIGIN_REMOTE $branch
    or begin
        __ft_log err "git push failed"
        return 1
    end
    __ft_log ok "pushed $branch"
    return 0
end
