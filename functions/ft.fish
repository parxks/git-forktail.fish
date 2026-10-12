# ft — git-forktail
# Idempotent GitHub fork bootstrapper.
# Entry point. All helpers live in sibling `__ft_*.fish` files
# and are autoloaded on first call.

function ft --description 'git-forktail — idempotent GitHub fork bootstrapper'
    # -----------------------------------------------------------------
    #  Version fallback (normally set by conf.d/git-forktail.fish)
    # -----------------------------------------------------------------
    set -q __ft_version; or set -g __ft_version 1.0.0

    # -----------------------------------------------------------------
    #  Color auto-detection
    # -----------------------------------------------------------------
    if set -q NO_COLOR; or not test -t 1
        set -g __ft_no_color 1
    else
        set -e -g __ft_no_color
    end

    # -----------------------------------------------------------------
    #  Argument parsing
    # -----------------------------------------------------------------
    argparse -n 'ft' \
        's/source=' 'd/dest=' 'n/name=' 'p/path=' \
        'fork-name=' 'upstream=' 'origin=' \
        'dry-run' 'v/verbose' 'q/quiet' \
        'V/version' 'h/help' 'u/usage' \
        -- $argv 2>/dev/null
    or begin
        __ft_log err "invalid arguments"
        __ft_usage
        return 2
    end

    if set -q _flag_version
        echo "git-forktail $__ft_version"
        return 0
    end
    if set -q _flag_help
        __ft_help
        return 0
    end
    if set -q _flag_usage
        __ft_usage
        return 0
    end

    # -----------------------------------------------------------------
    #  Global flags consumed by __ft_log
    # -----------------------------------------------------------------
    if set -q _flag_quiet
        set -g __ft_quiet 1
    else
        set -e -g __ft_quiet
    end
    if set -q _flag_verbose
        set -g __ft_verbose 1
    else
        set -e -g __ft_verbose
    end

    # -----------------------------------------------------------------
    #  Remote name defaults / overrides
    # -----------------------------------------------------------------
    set -q FT_UPSTREAM_REMOTE; or set -g FT_UPSTREAM_REMOTE upstream
    set -q FT_ORIGIN_REMOTE;   or set -g FT_ORIGIN_REMOTE   origin
    if set -q _flag_upstream
        set -g FT_UPSTREAM_REMOTE $_flag_upstream
    end
    if set -q _flag_origin
        set -g FT_ORIGIN_REMOTE $_flag_origin
    end

    # -----------------------------------------------------------------
    #  Positional STATE
    # -----------------------------------------------------------------
    set -l state auto
    if test (count $argv) -gt 0
        set state $argv[1]
    end
    if not contains -- $state auto neither github-only local-only both
        __ft_log err "unknown state: $state"
        __ft_usage
        return 2
    end

    # -----------------------------------------------------------------
    #  Resolve source
    # -----------------------------------------------------------------
    set -l source ""
    if set -q _flag_source
        set source $_flag_source
    else if set -q FT_DEFAULT_SOURCE
        set source $FT_DEFAULT_SOURCE
    end
    if test -z "$source"; and test -d .git
        set source (git remote get-url origin 2>/dev/null)
        if test -n "$source"
            __ft_log info "inferred source from origin: "(__ft_c cyan)"$source"(__ft_c normal)
        end
    end
    if test -z "$source"
        __ft_log err "no source repo specified and none could be inferred"
        echo "  pass --source <owner/repo> or set FT_DEFAULT_SOURCE"
        return 2
    end
    set -l source_slug (__ft_slug "$source")

    # -----------------------------------------------------------------
    #  Resolve dest
    # -----------------------------------------------------------------
    set -l dest ""
    if set -q _flag_dest
        set dest $_flag_dest
    else if set -q FT_DEFAULT_DEST
        set dest $FT_DEFAULT_DEST
    end
    if test -z "$dest"
        set -l me (gh api user --jq .login 2>/dev/null)
        if test -z "$me"
            __ft_log err "cannot determine GitHub username (gh api user failed)"
            return 1
        end
        set dest "$me/"(basename "$source_slug")
    end

    # --fork-name → rebuild dest slug; otherwise derive from dest basename
    if set -q _flag_fork_name
        set -l owner (dirname (__ft_slug "$dest"))
        set dest "$owner/$_flag_fork_name"
    else
        set -l dest_base   (basename (__ft_slug "$dest"))
        set -l source_base (basename "$source_slug")
        if test "$dest_base" != "$source_base"
            set _flag_fork_name $dest_base
        end
    end
    set -l dest_slug (__ft_slug "$dest")

    # -----------------------------------------------------------------
    #  Resolve paths
    # -----------------------------------------------------------------
    set -l path $PWD
    if set -q _flag_path
        set path $_flag_path
    end

    set -l name ""
    if set -q _flag_name
        set name $_flag_name
    else
        set name (basename "$dest_slug")
    end
    set -l target_dir "$path/$name"

    set -l dry false
    set -q _flag_dry_run; and set dry true
    if test "$dry" = true
        __ft_log info (__ft_c --bold --yellow)"DRY RUN"(__ft_c normal)" — no changes will be made"
    end

    # -----------------------------------------------------------------
    #  Preflight
    # -----------------------------------------------------------------
    __ft_preflight; or return 1

    __ft_log vlog "source = $source_slug"
    __ft_log vlog "dest   = $dest_slug"
    __ft_log vlog "target = $target_dir"
    __ft_log vlog "state  = $state"

    # -----------------------------------------------------------------
    #  Auto-detect
    # -----------------------------------------------------------------
    if test "$state" = auto
        set state (__ft_state "$source_slug" "$dest_slug" "$target_dir")
        __ft_log info "auto-detected state: "(__ft_c --bold)"$state"(__ft_c normal)
    end

    # -----------------------------------------------------------------
    #  Dispatch
    # -----------------------------------------------------------------
    switch $state
        case neither
            __ft_ensure_fork   "$source_slug" "$dest_slug" "$_flag_fork_name" "$dry"; or return 1
            __ft_clone_fork    "$dest_slug" "$target_dir" "$dry";                      or return 1
            __ft_setup_remotes "$target_dir" "$source_slug" "$dest_slug" "$dry";       or return 1
            __ft_log ok "done — "(__ft_c --bold)"cd $target_dir"(__ft_c normal)

        case github-only
            __ft_clone_fork    "$dest_slug" "$target_dir" "$dry";                      or return 1
            __ft_setup_remotes "$target_dir" "$source_slug" "$dest_slug" "$dry";       or return 1
            __ft_log ok "done — "(__ft_c --bold)"cd $target_dir"(__ft_c normal)

        case local-only
            set -l repo_dir $PWD
            if not test -d "$repo_dir/.git"
                __ft_log err "local-only requires being inside a git repo"
                return 1
            end
            __ft_ensure_fork   "$source_slug" "$dest_slug" "$_flag_fork_name" "$dry";  or return 1
            __ft_setup_remotes "$repo_dir" "$source_slug" "$dest_slug" "$dry";         or return 1
            __ft_push_fork     "$repo_dir" "$dry";                                      or return 1
            __ft_log ok "done — local repo is now a fork of $source_slug"

        case both
            set -l repo_dir $target_dir
            if not test -d "$repo_dir/.git"
                set repo_dir $PWD
            end
            if not test -d "$repo_dir/.git"
                __ft_log err "cannot locate local clone"
                return 1
            end
            __ft_setup_remotes "$repo_dir" "$source_slug" "$dest_slug" "$dry"; or return 1
            __ft_log ok "already forked and cloned — remotes verified"
    end

    return 0
end
