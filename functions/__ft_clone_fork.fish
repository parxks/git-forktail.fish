# Idempotent: clone the fork locally.
#   $argv[1] dest slug
#   $argv[2] target directory
#   $argv[3] "true"|"false" dry-run flag

function __ft_clone_fork --description 'Clone fork locally if missing'
    set -l dest_slug  $argv[1]
    set -l target_dir $argv[2]
    set -l dry        $argv[3]

    if test -d "$target_dir/.git"
        __ft_log ok "already cloned: "(__ft_c --bold)"$target_dir"(__ft_c normal)
        return 0
    end

    if test -e "$target_dir"
        __ft_log err "path exists but is not a git repo: $target_dir"
        return 1
    end

    __ft_log step "cloning "(__ft_c cyan)"$dest_slug"(__ft_c normal)" → "(__ft_c --bold)"$target_dir"(__ft_c normal)

    if test "$dry" = true
        __ft_log vlog "(dry-run) gh repo clone $dest_slug $target_dir"
        return 0
    end

    gh repo clone $dest_slug "$target_dir"
    or begin
        __ft_log err "clone failed"
        return 1
    end
    __ft_log ok "cloned"
    return 0
end
