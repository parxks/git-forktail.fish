function __ft_usage --description 'Brief usage for git-forktail'
    echo (__ft_c --bold)" USAGE"(__ft_c normal)
    echo "  "(__ft_c cyan)"ft"(__ft_c normal)" [OPTIONS] ["(__ft_c yellow)"STATE"(__ft_c normal)"]"
    echo ""
    echo "  "(__ft_c --bold)"STATE"(__ft_c normal)" (positional, optional; default: auto)"
    echo "    "(__ft_c yellow)"auto"(__ft_c normal)"          auto-detect from environment"
    echo "    "(__ft_c yellow)"neither"(__ft_c normal)"       not forked on GitHub, not cloned locally"
    echo "    "(__ft_c yellow)"github-only"(__ft_c normal)"   forked on GitHub, not cloned locally"
    echo "    "(__ft_c yellow)"local-only"(__ft_c normal)"    cloned locally, not forked on GitHub"
    echo "    "(__ft_c yellow)"both"(__ft_c normal)"          already forked and cloned (verify + repair)"
    echo ""
    echo "  Run '"(__ft_c cyan)"ft --help"(__ft_c normal)"' for full options."
end
