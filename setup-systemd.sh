sudo tee /etc/systemd/system/ddns53.service << EOF
[Unit]
Description=Set an A record in an AWS Route 53 Hosted Zone to the current public IP address
Wants=network-online.target
After=syslog.target network-online.target

[Service]
Type=oneshot
ExecStart=$(dirname "$(readlink -f "$0")")/ddns53.sh
User=pi
EOF

sudo tee /etc/systemd/system/ddns53.timer << EOF
[Unit]
Description=Periodically update an A record

[Timer]
OnBootSec=15min
OnUnitActiveSec=15min

[Install]
WantedBy=timers.target
EOF