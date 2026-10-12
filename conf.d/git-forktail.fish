# Sourced on every shell start.
# Sets a global version and loads the optional user config file.
#
# User config lives at: $__fish_config_dir/git-forktail/config.fish
# Example contents:
#   set -g FT_DEFAULT_SOURCE "https://github.com/someone/repo.git"
#   set -g FT_DEFAULT_DEST   "git@github.com:you/repo.git"
#   set -g FT_UPSTREAM_REMOTE upstream
#   set -g FT_ORIGIN_REMOTE   origin

set -g __ft_version 1.0.0

set -l __ft_user_config $__fish_config_dir/git-forktail/config.fish
if test -f $__ft_user_config
    source $__ft_user_config
end
