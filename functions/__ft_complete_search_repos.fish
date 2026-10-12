# Completion helper — public GitHub search on the current token.
# Only fires once the user has typed >= 2 characters.
function __ft_complete_search_repos --description 'Search public repos for completion'
    set -l token (commandline -ct)
    if test (string length -- $token) -lt 2
        return 0
    end
    gh search repos --limit 15 --json fullName -q '.[].fullName' -- $token 2>/dev/null
end
