## TPM with Custom Config Path

To use TPM (Tmux Plugin Manager) with a custom config location without symlinks:

### Problem

TPM only searches for plugins in `~/.config/tmux/tmux.conf` or `~/.tmux.conf`. Custom paths are ignored.

### Solution

Create a bridge file at the standard location:

```bash
mkdir -p ~/.config/tmux
echo 'source-file ~/.tools/fconf/tmux/tmux.conf' > ~/.config/tmux/tmux.conf
