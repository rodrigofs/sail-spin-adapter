# Sail to Spin Adapter

A bash-based adapter that translates Laravel Sail commands to work with Spin. Includes smart project detection and conflict-free alias management.

## Features

- **Smart Project Detection**: Automatically detects Spin projects by checking for `.infrastructure/` directory
- **Command Translation**: Maps all Laravel Sail commands to their Spin equivalents  
- **Alias Management**: Safely switches between Laravel Sail and Spin without conflicts
- **Zero Configuration**: Works out of the box with any Spin project

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rodrigofs/sail-spin-adapter/main/install.sh | bash
```

After installation:
```bash
sail-manager activate   # Use Spin adapter
```

## Quick Start

```bash
# Navigate to any project and auto-detect:
cd ~/projects/my-spin-project
sail-auto  # Automatically activates Spin adapter
sail up -d # Uses Spin commands

cd ~/projects/my-laravel-project  
sail-auto  # Automatically switches to Laravel Sail
sail up -d # Uses Laravel Sail
```

## Project Detection

The adapter automatically detects project type:

**Spin Projects** (detected by):
- `.infrastructure/` directory

**Laravel Sail Projects** (detected by):
- `vendor/bin/sail` file
- `laravel.test` in docker-compose files

## Management Commands

```bash
sail-manager auto        # Auto-detect and switch (recommended)
sail-manager status      # Check current mode and project type
sail-manager activate    # Force Spin adapter
sail-manager deactivate  # Force Laravel Sail  
sail-manager update      # Update adapter
```

## How It Works

The manager works by switching shell aliases:
- **Laravel Sail**: `alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'`
- **Spin Adapter**: `alias sail='~/.sail-spin-adapter/sail-spin'`

The adapter script translates Sail commands to Spin equivalents automatically.

## Supported Commands

### Container Management
```bash
sail up -d         # Start containers
sail down          # Stop containers  
sail ps            # List containers
sail logs          # View logs
```

### Laravel Development
```bash
sail art migrate           # Run migrations
sail art make:controller   # Create controller
sail composer install     # Install PHP dependencies
sail tinker               # Laravel tinker
sail test                 # Run tests
sail php -v               # Check PHP version
```

### Frontend Development
```bash
sail npm run dev    # Start Vite dev server
sail npm install   # Install Node packages
sail yarn add pkg   # Add package with Yarn
```

### Database Access
```bash
sail mysql       # Connect to MySQL
sail postgres    # Connect to PostgreSQL  
sail redis       # Redis CLI
```

### Shell Access
```bash
sail bash        # Access PHP container
sail exec php bash  # Custom exec commands
```

## Command Translation

The adapter translates commands automatically:

| Laravel Sail Command | Spin Equivalent |
|---------------------|-----------------|
| `sail up -d` | `spin up -d` |
| `sail art migrate` | `spin exec php php artisan migrate` |
| `sail composer install` | `spin exec php composer install` |
| `sail npm run dev` | `spin run node npm run dev` |
| `sail mysql` | `spin exec mysql mysql -u root -p` |
| `sail bash` | `spin exec php bash` |

## Requirements

- **Spin**: Must be installed and available in PATH
- **curl**: For installation and updates  
- **bash**: Shell environment

## Removal

```bash
sudo rm /usr/local/bin/sail-manager
rm -rf ~/.sail-spin-adapter
# Remove aliases from shell profile manually
```

---

⭐ **[Give us a star](https://github.com/rodrigofs/sail-spin-adapter) if this project helped you!**