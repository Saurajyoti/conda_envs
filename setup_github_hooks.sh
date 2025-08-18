#!/bin/bash

# === Setup GitHub Token for Conda (Global Hooks) ===

# Ask for username
read -p "Enter your GitHub username: " GITHUB_USER

# Check for token file
if [[ ! -f "$HOME/.github_token" ]]; then
    echo "❌ No token file found at ~/.github_token"
    echo "Create one with: nano ~/.github_token"
    exit 1
fi

# Make sure only you can read the token
chmod 600 ~/.github_token

# Get conda base path
CONDA_BASE=$(conda info --base)

# Create hook directories
mkdir -p $CONDA_BASE/etc/conda/activate.d
mkdir -p $CONDA_BASE/etc/conda/deactivate.d

# Create activation script
cat <<EOF > $CONDA_BASE/etc/conda/activate.d/github_vars.sh
#!/bin/bash
export GITHUB_USER="$GITHUB_USER"
export GITHUB_TOKEN=\$(cat ~/.github_token)
EOF

# Create deactivation script
cat <<EOF > $CONDA_BASE/etc/conda/deactivate.d/github_vars.sh
#!/bin/bash
unset GITHUB_USER
unset GITHUB_TOKEN
EOF

# Make scripts executable
chmod +x $CONDA_BASE/etc/conda/activate.d/github_vars.sh
chmod +x $CONDA_BASE/etc/conda/deactivate.d/github_vars.sh

echo "✅ GitHub token hook installed."
echo "➡️  Run: conda deactivate && conda activate base"
echo "➡️  Then check: echo \$GITHUB_USER"

