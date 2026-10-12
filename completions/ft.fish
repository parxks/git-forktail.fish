# Tab completion for `ft` (git-forktail).
# Colored descriptions for every flag and positional state.

complete -c ft -f

# ------------------------------------------------------------------
#  Options
# ------------------------------------------------------------------
complete -c ft -s s -l source -x \
    -a '(__ft_complete_search_repos)(__ft_complete_my_repos)' \
    -d (set_color cyan)'Upstream source repo (owner/repo or URL)'(set_color normal)

complete -c ft -s d -l dest -x \
    -a '(__ft_complete_my_repos)' \
    -d (set_color cyan)'Destination fork (owner/repo or URL)'(set_color normal)

complete -c ft -s n -l name -x \
    -d (set_color cyan)'Local directory name'(set_color normal)

complete -c ft -s p -l path -x \
    -a '(__fish_complete_directories)' \
    -d (set_color cyan)'Parent directory for clone (default: $PWD)'(set_color normal)

complete -c ft -l fork-name -x \
    -d (set_color cyan)'Rename the fork on GitHub when creating'(set_color normal)

complete -c ft -l upstream -x \
    -d (set_color cyan)'Upstream remote name (default: upstream)'(set_color normal)

complete -c ft -l origin -x \
    -d (set_color cyan)'Origin remote name (default: origin)'(set_color normal)

complete -c ft -l dry-run \
    -d (set_color yellow)'Show actions without executing them'(set_color normal)

complete -c ft -s v -l verbose \
    -d (set_color green)'Verbose output'(set_color normal)

complete -c ft -s q -l quiet \
    -d (set_color green)'Quiet mode — errors only'(set_color normal)

complete -c ft -s V -l version \
    -d (set_color brblue)'Print version'(set_color normal)

complete -c ft -s h -l help \
    -d (set_color brblue)'Show full help'(set_color normal)

complete -c ft -s u -l usage \
    -d (set_color brblue)'Show brief usage'(set_color normal)

# ------------------------------------------------------------------
#  Positional: STATE
# ------------------------------------------------------------------
set -l __ft_seen 'not __fish_seen_subcommand_from auto neither github-only local-only both'

complete -c ft -n $__ft_seen -a auto \
    -d (set_color yellow)'Auto-detect state from environment (default)'(set_color normal)

complete -c ft -n $__ft_seen -a neither \
    -d (set_color yellow)'Not forked on GitHub, not cloned locally'(set_color normal)

complete -c ft -n $__ft_seen -a github-only \
    -d (set_color yellow)'Forked on GitHub, not cloned locally'(set_color normal)

complete -c ft -n $__ft_seen -a local-only \
    -d (set_color yellow)'Cloned locally, not forked on GitHub'(set_color normal)

complete -c ft -n $__ft_seen -a both \
    -d (set_color yellow)'Already forked and cloned (verify + repair)'(set_color normal)
