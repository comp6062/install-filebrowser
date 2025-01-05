#!/bin/bash

# Step 1: Download and install Filebrowser
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Step 2: Create the systemd service file
sudo bash -c 'cat > /etc/systemd/system/filebrowser.service <<EOF
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
EOF'

# Step 3: Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Step 4: Enable the service to start on boot
sudo systemctl enable filebrowser

# Step 5: Start the Filebrowser service
sudo systemctl start filebrowser

# Step 6: Verify if the service is running
if systemctl is-active --quiet filebrowser; then
    echo "Filebrowser is running successfully!"
else
    echo "Filebrowser failed to start. Check the logs with: sudo journalctl -u filebrowser"
    exit 1
fi

# Step 7: Clean up and exit
echo "Installation complete. Filebrowser is set up and running."
exit 0
