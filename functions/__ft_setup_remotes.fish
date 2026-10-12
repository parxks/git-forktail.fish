# Idempotent: ensure origin → fork and upstream → source.
#   $argv[1] repo directory
#   $argv[2] source slug
#   $argv[3] dest slug
#   $argv[4] "true"|"false" dry-run flag

function __ft_setup_remotes --description 'Ensure origin/upstream remotes are correct'
    set -l repo_dir    $argv[1]
    set -l source_slug $argv[2]
    set -l dest_slug   $argv[3]
    set -l dry         $argv[4]

    set -l source_ssh "git@github.com:$source_slug.git"
    set -l dest_ssh   "git@github.com:$dest_slug.git"

    # --- origin → fork ---
    set -l origin_url (git -C "$repo_dir" remote get-url $FT_ORIGIN_REMOTE 2>/dev/null)
    if test -z "$origin_url"
        __ft_log step "adding $FT_ORIGIN_REMOTE → $dest_slug"
        if test "$dry" != true
            git -C "$repo_dir" remote add $FT_ORIGIN_REMOTE $dest_ssh
            or begin
                __ft_log err "failed to add origin remote"
                return 1
            end
        end
    else if not string match -q -- "*$dest_slug*" "$origin_url"
        set -l upstream_url (git -C "$repo_dir" remote get-url $FT_UPSTREAM_REMOTE 2>/dev/null)
        if test -z "$upstream_url"
            __ft_log step "renaming $FT_ORIGIN_REMOTE → $FT_UPSTREAM_REMOTE"
            if test "$dry" != true
                git -C "$repo_dir" remote rename $FT_ORIGIN_REMOTE $FT_UPSTREAM_REMOTE
                git -C "$repo_dir" remote add    $FT_ORIGIN_REMOTE $dest_ssh
            end
        else
            __ft_log step "setting $FT_ORIGIN_REMOTE → $dest_slug"
            if test "$dry" != true
                git -C "$repo_dir" remote set-url $FT_ORIGIN_REMOTE $dest_ssh
            end
        end
    else
        __ft_log ok "$FT_ORIGIN_REMOTE → $dest_slug"
    end

    # --- upstream → source ---
    set -l upstream_url (git -C "$repo_dir" remote get-url $FT_UPSTREAM_REMOTE 2>/dev/null)
    if test -z "$upstream_url"
        __ft_log step "adding $FT_UPSTREAM_REMOTE → $source_slug"
        if test "$dry" != true
            git -C "$repo_dir" remote add $FT_UPSTREAM_REMOTE $source_ssh
            or begin
                __ft_log err "failed to add upstream remote"
                return 1
            end
        end
    else
        __ft_log ok "$FT_UPSTREAM_REMOTE → $source_slug"
    end

    return 0
end
