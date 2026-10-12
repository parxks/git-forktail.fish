function __ft_help --description 'Full help for git-forktail'
    set -q __ft_version; or set -l __ft_version 1.0.0
    echo (__ft_c --bold --cyan)"git-forktail"(__ft_c normal)" v$__ft_version — idempotent GitHub fork bootstrapper"
    echo ""
    __ft_usage
    echo ""
    echo (__ft_c --bold)" OPTIONS"(__ft_c normal)
    set -l G (__ft_c green); set -l R (__ft_c normal); set -l D (__ft_c brblack)
    printf "  %s\n" \
        "$G-s, --source <REPO>$R      upstream source (owner/repo or URL)" \
        "$G-d, --dest <REPO>$R        destination fork (owner/repo or URL)" \
        "$G-n, --name <NAME>$R        local directory name (default: repo basename)" \
        "$G-p, --path <DIR>$R         parent directory for clone (default: \$PWD)" \
        "$G    --fork-name <NAME>$R   rename the fork on GitHub" \
        "$G    --upstream <NAME>$R    upstream remote name (default: upstream)" \
        "$G    --origin <NAME>$R      origin remote name (default: origin)" \
        "$G    --dry-run$R            show actions without executing" \
        "$G-v, --verbose$R            verbose output" \
        "$G-q, --quiet$R              quiet (errors only)" \
        "$G-V, --version$R            print version" \
        "$G-h, --help$R               show this help" \
        "$G-u, --usage$R              show brief usage"
    echo ""
    echo (__ft_c --bold)" EXAMPLES"(__ft_c normal)
    echo "  $D# full bootstrap from scratch (fork on GitHub + clone locally)$R"
    echo "  ft -s octocat/Hello-World neither"
    echo ""
    echo "  $D# clone an existing fork into ./hello$R"
    echo "  ft -s octocat/Hello-World -n hello github-only"
    echo ""
    echo "  $D# fork the repo you are currently inside of$R"
    echo "  ft local-only"
    echo ""
    echo "  $D# rename the fork on GitHub during bootstrap$R"
    echo "  ft -s octocat/Hello-World --fork-name my-hello neither"
    echo ""
    echo "  $D# dry run$R"
    echo "  ft -s octocat/Hello-World --dry-run"
    echo ""
    echo (__ft_c --bold)" ENVIRONMENT"(__ft_c normal)
    echo "  NO_COLOR              disable color output"
    echo "  FT_DEFAULT_SOURCE     fallback source repo"
    echo "  FT_DEFAULT_DEST       fallback destination fork"
    echo "  FT_UPSTREAM_REMOTE    upstream remote name (default: upstream)"
    echo "  FT_ORIGIN_REMOTE      origin remote name   (default: origin)"
    echo ""
    echo (__ft_c --bold)" CONFIG FILE"(__ft_c normal)
    echo "  \$__fish_config_dir/git-forktail/config.fish"
end
