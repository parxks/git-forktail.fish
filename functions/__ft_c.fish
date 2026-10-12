# Return a set_color code, or nothing when __ft_no_color is set.
# Usage: (__ft_c cyan)  (__ft_c --bold)  (__ft_c normal)

function __ft_c --description 'Colour code helper respecting NO_COLOR'
    if set -q __ft_no_color
        return 0
    end
    set_color $argv
end
