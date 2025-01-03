#!/bin/bash

# Function to install FileBrowser
install_filebrowser() {
    echo "Installing FileBrowser..."

    # Download and run the installation script
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

    # Create a systemd service file
    echo "Creating systemd service file for FileBrowser..."
    cat <<EOL > /etc/systemd/system/filebrowser.service
[Unit]
Description=Filebrowser Service
After=network.target

[Service]
ExecStart=/usr/local/bin/filebrowser -a 0.0.0.0 -r /
Restart=always
User=root
Group=root
WorkingDirectory=/root

[Install]
WantedBy=multi-user.target
EOL

    # Reload systemd and enable the service
    echo "Reloading systemd and enabling FileBrowser..."
    sudo systemctl daemon-reload
    sudo systemctl enable filebrowser

    # Start the service
    echo "Starting FileBrowser service..."
    sudo systemctl start filebrowser

    # Verify the service status
    echo "Verifying FileBrowser service status..."
    sudo systemctl status filebrowser
}

# Function to uninstall FileBrowser
uninstall_filebrowser() {
    echo "Uninstalling FileBrowser..."

    # Stop the service
    echo "Stopping FileBrowser service..."
    sudo systemctl stop filebrowser

    # Disable the service
    echo "Disabling FileBrowser service..."
    sudo systemctl disable filebrowser

    # Remove the service file
    echo "Removing systemd service file..."
    sudo rm -f /etc/systemd/system/filebrowser.service

    # Reload systemd
    echo "Reloading systemd..."
    sudo systemctl daemon-reload

    # Remove FileBrowser binary
    echo "Removing FileBrowser binary..."
    sudo rm -f /usr/local/bin/filebrowser

    echo "FileBrowser uninstalled successfully."
}

# Main menu
main_menu() {
    echo "Select an option:"
    echo "1) Install FileBrowser"
    echo "2) Uninstall FileBrowser"
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1)
            install_filebrowser
            ;;
        2)
            uninstall_filebrowser
            ;;
        *)
            echo "Invalid choice. Exiting."
            ;;
    esac
}

# Start the script
main_menu
