# Completion helper — repos owned by the authenticated gh user.
function __ft_complete_my_repos --description 'List authenticated user repos for completion'
    gh repo list --limit 60 --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null
end
