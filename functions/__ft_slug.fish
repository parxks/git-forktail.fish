# Normalize any repo reference (URL, ssh, owner/repo, .git suffix) → owner/repo
function __ft_slug --description 'Normalize a repo reference to owner/repo'
    set -l v $argv[1]
    set v (string replace -r '^git@[^:]+:'      '' -- $v)
    set v (string replace -r '^https?://[^/]+/' '' -- $v)
    set v (string replace -r '^ssh://[^/]+/'    '' -- $v)
    set v (string replace -r '^git://[^/]+/'    '' -- $v)
    set v (string replace -r '\.git$'           '' -- $v)
    set v (string replace -r '/+$'              '' -- $v)
    echo $v
end
