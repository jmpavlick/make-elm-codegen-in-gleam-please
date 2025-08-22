GLEAM ENVIRONMENT SETUP - FAST TRACK

Set up a working Gleam development environment that can compile to JavaScript. Follow these exact steps:

1. Install Gleam (Linux/macOS):

# Download and install Gleam v1.11.0+ (required for latest stdlib)
curl -L -o gleam.tar.gz "https://github.com/gleam-lang/gleam/releases/download/v1.11.0/gleam-v1.11.0-x86_64-unknown-linux-musl.tar.gz"
tar -xzf gleam.tar.gz
chmod +x gleam
sudo mv gleam /usr/local/bin/
# OR just keep it local: export PATH="$PWD:$PATH"
2. Verify Installation:

gleam --version  # Should show 1.11.0+
3. Create New Project:

gleam new my_project
cd my_project
4. Add Dependencies (if needed):

# For web frontends
gleam add lustre

# For JSON handling  
gleam add gleam_json

# For HTTP clients
gleam add lustre_http
5. Build & Test:

# Build for JavaScript (browser/Node.js)
gleam build --target javascript

# Build for Erlang (server/CLI)
gleam build --target erlang  # Requires Erlang/OTP installed

# Run tests
gleam test
Key Points:

JavaScript target: No Erlang required, outputs to build/dev/javascript/
Erlang target: Requires Erlang/OTP installation
Version: Use 1.11.0+ for compatibility with latest packages
Package manager: Built-in, no separate tool needed
Common Issues:

If you get "Incompatible Gleam version" → upgrade Gleam
If HTTP requests fail during gleam add → network/firewall issue
If building for JavaScript fails → check you're not using Erlang-specific modules
This should get you a working Gleam environment in ~2 minutes.
