My personal neovim config.

- If you want to use Powershell on Windows as your default terminal update 
- If no native grep is available, install ripgrep: https://github.com/BurntSushi/ripgrep
- When installing treesitter on Windows you may need to install mingw in order to get a compatible C compiler: https://www.reddit.com/r/neovim/comments/14oozmu/neovim_cant_find_c_compiler/

## PHP Development Setup

### Automatic Installations (via Mason)
The following are automatically installed when you open Neovim:
- **Intelephense** - PHP Language Server for code intelligence
- **PHP Debug Adapter** - For debugging with XDebug

### External Tools (Manual Installation Required)

#### Composer (Dependency Manager)
Install Composer first - it's required for most PHP development tools:
```bash
# Visit https://getcomposer.org/download/ for official installation
# Or use your system package manager:
sudo pacman -S composer  # Arch Linux
sudo apt install composer  # Ubuntu/Debian
brew install composer  # macOS
```

#### PHP Formatting & Linting Tools
Install these tools globally via Composer:

```bash
# PHP-CS-Fixer - Auto-formatter for PHP code (PSR-12, Symfony, Laravel styles)
composer global require friendsofphp/php-cs-fixer

# PHP_CodeSniffer - Code linting and standards checking
composer global require squizlabs/php_codesniffer
# Note: This includes both phpcs (linter) and phpcbf (auto-fixer)

# PHPStan - Static analysis tool for finding bugs
composer global require phpstan/phpstan
```

**Important**: Make sure Composer's global bin directory is in your PATH:
```bash
# Add to your .bashrc, .zshrc, or equivalent:
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
```

#### PHP Debugging (XDebug)
For debugging support with nvim-dap, install XDebug:

```bash
# Arch Linux
sudo pacman -S xdebug

# Ubuntu/Debian
sudo apt install xdebug

# macOS (via PECL)
pecl install xdebug
```

Configure XDebug for debugging:

**Arch Linux** - Edit `/etc/php/conf.d/xdebug.ini`:
```ini
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_port=9003
```

**Other systems** - Add to your `php.ini` file (find location with `php --ini`):
```ini
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_port=9003
```

### Debugging Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start/Continue debugging |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>dr` | Open debug REPL |
| `<leader>dl` | Run last debug configuration |
| `<leader>dt` | Terminate debugging session |
| `<leader>du` | Toggle debug UI |

### Per-Project Alternative
Instead of global installation, you can install tools per-project:
```bash
composer require --dev friendsofphp/php-cs-fixer
composer require --dev squizlabs/php_codesniffer
composer require --dev phpstan/phpstan
```

Note: When using per-project installation, none-ls will automatically detect tools in `./vendor/bin/`.

### What Works Without External Tools

**Immediate functionality (no external tools needed)**:
- Code completion and IntelliSense (via Intelephense)
- Go-to-definition, hover documentation, references
- Syntax highlighting (via Treesitter)
- Basic LSP diagnostics (via Intelephense)

**Requires external tools**:
- Code formatting (requires php-cs-fixer or phpcbf)
- Code linting (requires phpcs)
- Static analysis (requires phpstan)
- Debugging (requires XDebug)

