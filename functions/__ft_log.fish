# Internal levelled logger for git-forktail.
# Levels: info | ok | step | warn | err | vlog
# Honours globals: __ft_quiet, __ft_verbose

function __ft_log --description 'Internal logger for git-forktail'
    set -l level $argv[1]
    set -l msg   $argv[2..-1]

    if set -q __ft_quiet; and contains -- $level info ok step vlog
        return 0
    end

    if test "$level" = vlog; and not set -q __ft_verbose
        return 0
    end

    set -l tag
    set -l color normal
    switch $level
        case info
            set tag "[info]"; set color blue
        case ok
            set tag "[ ok ]"; set color green
        case step
            set tag "  ->";   set color magenta
        case warn
            set tag "[warn]"; set color yellow
        case err
            set tag "[ err]"; set color red
        case vlog
            set tag "    .";  set color brblack
        case '*'
            set tag "[????]"; set color normal
    end

    set -l line (__ft_c $color)"$tag"(__ft_c normal)" $msg"

    if test "$level" = warn; or test "$level" = err
        echo $line >&2
    else
        echo $line
    end
end
