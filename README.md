# git-forktail 🐟

> Idempotent fish-shell GitHub fork bootstrapper built on top of the `gh` CLI.

`git-forktail` installs a single command — **`ft`** — that brings any repo to a
consistent "forked + cloned" state, no matter which of the four possible states
you're currently in. Safe to re-run at any time.

Named after the **forktail** — a small, fast fish whose name literally contains
the word *fork*.

## States

| State          | Meaning                                    | Action                                      |
|----------------|--------------------------------------------|---------------------------------------------|
| `neither`      | Not forked on GitHub, not cloned locally   | `gh repo fork` + `gh repo clone` + remotes  |
| `github-only`  | Forked on GitHub, not cloned locally       | `gh repo clone` + remotes                   |
| `local-only`   | Cloned locally, not forked on GitHub       | `gh repo fork` + remotes + `git push`       |
| `both`         | Already forked **and** cloned              | Verify + repair remotes                     |
| `auto`         | *(default)* auto-detect the above          | Whatever detection says                     |

After any state, the repo ends up with the standard fork layout:

- `origin`   → your fork   (`git@github.com:<you>/<repo>.git`)
- `upstream` → source repo (`git@github.com:<source>/<repo>.git`)

## Installation

### With [fisher](https://github.com/jorgebucaran/fisher)

```fish
fisher install <your-user>/git-forktail
```

### Manually

```
git clone https://github.com/<your-user>/git-forktail \
    ~/.config/fish/plugins/git-forktail

for f in ~/.config/fish/plugins/git-forktail/functions/*.fish
    ln -sf $f ~/.config/fish/functions/
end
ln -sf ~/.config/fish/plugins/git-forktail/completions/ft.fish \
       ~/.config/fish/completions/ft.fish
ln -sf ~/.config/fish/plugins/git-forktail/conf.d/git-forktail.fish \
       ~/.config/fish/conf.d/git-forktail.fish
```

Fisher is strongly recommended — it wires up `functions/`, `completions/` and
`conf.d/` automatically.

## Configuration

Create `~/.config/fish/git-forktail/config.fish` (sourced automatically by
`conf.d/git-forktail.fish`) and set your personal defaults:

```
set -g FT_DEFAULT_SOURCE "https://github.com/OWNER/REPO.git"
set -g FT_DEFAULT_DEST   "git@github.com:YOU/REPO.git"

# optional — override remote names
set -g FT_UPSTREAM_REMOTE upstream
set -g FT_ORIGIN_REMOTE   origin
```

Everything can also be overridden per-run with `-s` / `-d`.

## Prerequisites

- `fish` ≥ 3.0
- `gh` CLI, authenticated (`gh auth status`)
- `git`
- `ssh-agent` running with your GitHub key loaded (for SSH pushes)

## Usage

```
ft [OPTIONS] [STATE]
```

### Options

| Flag ↕▾ | Description ↕▾ |
|---|---|
| −`-s, --source <REPO>` | Upstream source (owner/repo, URL, or ssh) |
| `-d, --dest <REPO>` | Destination fork (owner/repo, URL, or ssh) |
| `-n, --name <NAME>` | Local directory name (default: repo basename) |
| `-p, --path <DIR>` | Parent directory for the clone (default: `$PWD`) |
| `--fork-name <NAME>` | Rename the fork on GitHub during creation |
| `--upstream <NAME>` | Override `upstream` remote name |
| `--origin <NAME>` | Override `origin` remote name |
| `--dry-run` | Print actions without executing |
| `-v, --verbose` | Verbose output |
| `-q, --quiet` | Errors only |
| `-V, --version` | Print version |
| `-h, --help` | Full help |
| `-u, --usage` | Brief usage |
⚙

### Examples

```
# Full bootstrap from scratch: fork on GitHub + clone locally
ft -s octocat/Hello-World neither

# Clone your existing fork into ./hello
ft -s octocat/Hello-World -n hello github-only

# Fork the repo you're currently inside of
ft local-only

# Create the fork under a custom name on GitHub
ft -s octocat/Hello-World --fork-name my-hello neither

# Preview changes
ft -s octocat/Hello-World --dry-run
```

## Environment variables

| Var ↕▾ | Effect ↕▾ |
|---|---|
| −`NO_COLOR` | Disable ANSI colors |
| −`FT_DEFAULT_SOURCE` | Fallback source repo |
| `FT_DEFAULT_DEST` | Fallback destination fork |
| `FT_UPSTREAM_REMOTE` | Upstream remote name (default `upstream`) |
| `FT_ORIGIN_REMOTE` | Origin remote name (default `origin`) |
⚙

## Idempotency guarantees

- Re-running in `both` state is a no-op except for remote repairs.
- `gh repo fork` is only called if the fork does not already exist.
- `gh repo clone` is only called if the target directory is not already a repo.
- Remote add / rename / set-url are all guarded by existence checks.
- `git push -u` is safe to repeat.
- Any unexpected error aborts the run with a non-zero exit code, leaving the
repo in a consistent (if partial) state that the next run will repair.

## Project layout

```
git-forktail/
├── completions/
│   └── ft.fish                  # tab completion for `ft`
├── conf.d/
│   └── git-forktail.fish        # shell-init: version + user config
├── functions/
│   ├── ft.fish                  # main entry point
│   └── __ft_*.fish              # private autoloaded helpers
├── .github/workflows/ci.yml     # syntax + smoke tests
├── LICENSE
└── README.md
```

## Uninstall

```
fisher remove <your-user>/git-forktail
```

or manually:

```
rm ~/.config/fish/functions/ft.fish
rm ~/.config/fish/functions/__ft_*.fish
rm ~/.config/fish/completions/ft.fish
rm ~/.config/fish/conf.d/git-forktail.fish
```

## License

MIT — see LICENSE.

