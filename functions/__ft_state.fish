# Detect current state of {source,dest} pair.
# Returns: neither | github-only | local-only | both
#
#   $argv[1] source slug (owner/repo)
#   $argv[2] dest slug   (owner/repo)
#   $argv[3] target directory for local clone

function __ft_state --description 'Detect bootstrap state'
    set -l source_slug $argv[1]
    set -l dest_slug   $argv[2]
    set -l target_dir  $argv[3]

    set -l remote 0
    if gh repo view $dest_slug >/dev/null 2>&1
        set remote 1
    end

    set -l local 0
    if test -n "$target_dir"; and test -d "$target_dir/.git"
        set local 1
    else if test -d .git
        set -l pwd_origin (git remote get-url origin 2>/dev/null)
        if test -n "$pwd_origin"
            set -l pwd_slug (__ft_slug "$pwd_origin")
            if test "$pwd_slug" = "$source_slug"; or test "$pwd_slug" = "$dest_slug"
                set local 1
            end
        end
    end

    if test $local -eq 1; and test $remote -eq 1
        echo both
    else if test $local -eq 1
        echo local-only
    else if test $remote -eq 1
        echo github-only
    else
        echo neither
    end
end
