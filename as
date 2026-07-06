#!/usr/bin/env bash

# ==============================================================================
#  PROJECT: NorixOS Cyber Terminal Pack (Updated Anime Cyberpunk Logo)
#  SUPPORT: Debian / Ubuntu 24.04 (SSH / No-GUI Only)
#  PALETTE: Cyber Blue (#00FFFF / #00D7FF) & Cyber Purple (#D700FF / #AF00FF)
# ==============================================================================

# Màu sắc thông báo hệ thống
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}======================================================${NC}"
echo -e "${CYAN}   CẬP NHẬT GIAO DIỆN NORIXOS - ANIME CYBERPUNK LOGO  ${NC}"
echo -e "${PURPLE}======================================================${NC}"

# 1. Khởi tạo & Cài đặt các Package nền tảng
echo -e "${GREEN}[1/6] Đang đồng bộ và cài đặt các gói cần thiết...${NC}"
sudo apt update -y
sudo apt install -y curl wget git zsh btop tmux neofetch unzip sed

# 2. Cài đặt Fastfetch bản mới nhất (Thay thế Neofetch đã khai tử)
if ! command -v fastfetch &> /dev/null; then
    echo -e "${GREEN}[2/6] Đang tải Fastfetch phiên bản mới nhất...${NC}"
    FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)
    if [ -n "$FASTFETCH_URL" ]; then
        wget -qO /tmp/fastfetch.deb "$FASTFETCH_URL"
        sudo dpkg -i /tmp/fastfetch.deb || sudo apt-get install -f -y
    else
        sudo apt install -y fastfetch
    fi
fi

# 3. Cài đặt Starship Prompt làm đẹp dòng lệnh
if ! command -v starship &> /dev/null; then
    echo -e "${GREEN}[3/6] Cài đặt Starship Prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# 4. Định hình cấu trúc Fastfetch mới với Logo Anime Cyberpunk dạng ANSI
echo -e "${GREEN}[4/6] Đang cấu hình Logo Anime & Thông số hệ thống...${NC}"
mkdir -p ~/.config/fastfetch

cat << 'EOF' > ~/.config/fastfetch/config.jsonc
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "string",
    "source": "\u001b[36m       .---.       .---.\n      /     \\     /     \\\n      \\   _  \\   /  _   /\n       | (_)  | |  (_) |\n   .-.  \\    /   \\    /  .-.\n  |   \\  '--'     '--'  /   |\n   \\   '--._________ .--'  /\n    '--.________________.--'\n     \u001b[35m /  ▲ ▲          ▲ ▲  \\\n     |   ■ ■          ■ ■   |\n     |        \u001b[36m  ▄▄▄  \u001b[35m       |\n      \\        \u001b[36m▀███▀\u001b[35m       /\n    \u001b[36m_..-'#-------------'#-.._\n   /                         \\\n  |  \u001b[35m[ CYBER ANIME INTERFACE ]\u001b[36m  |\n  \\                           /\n   '--.._________________..--'\n       \u001b[35m||             ||\n       []             []\u001b[0m",
    "padding": {
      "right": 4
    }
  },
  "display": {
    "separator": " ──❯ "
  },
  "modules": [
    { "type": "title", "key": "  SYSTEM", "keyColor": "36" },
    { "type": "os", "key": "  OS", "keyColor": "36" },
    { "type": "kernel", "key": "  Kernel", "keyColor": "36" },
    { "type": "uptime", "key": "  Uptime", "keyColor": "36" },
    { "type": "shell", "key": "  Shell", "keyColor": "36" },
    "break",
    { "type": "cpu", "key": "  CPU", "keyColor": "35" },
    { "type": "gpu", "key": "  GPU", "keyColor": "35" },
    { "type": "memory", "key": "  RAM", "keyColor": "35" },
    { "type": "disk", "key": "  Disk", "keyColor": "35" },
    { "type": "localip", "key": "  Ping/IP", "keyColor": "35" },
    "break",
    { "type": "colors", "symbol": "diamond" }
  ]
}
EOF

# 5. Cấu hình SSH MOTD Động (Hiện thông số CPU, RAM, GPU, Ping khi vừa đăng nhập)
echo -e "${GREEN}[5/6] Thiết lập màn hình đăng nhập động (MOTD)...${NC}"
sudo chmod -x /etc/update-motd.d/* 2>/dev/null || true
sudo mkdir -p /etc/update-motd.d

cat << 'EOF' | sudo tee /etc/update-motd.d/99-norixos-motd
#!/usr/bin/env bash
clear
echo -e "\e[1;36m"
echo "███╗   ██╗ ██████╗ ██████╗ ██╗██╗  ██╗ ██████╗ ██████╗"
echo "████╗  ██║██╔═══██╗██╔══██╗██║╚██╗██╔╝██╔═══██╗██╔════╝"
echo "██╔██╗ ██║██║   ██║██████╔╝██║ ╚███╔╝ ██║   ██║███████╗"
echo "██║╚██╗██║██║   ██║██╔══██╗██║ ██╔██╗ ██║   ██║╚════██║"
echo "██║ ╚████║╚██████╔╝██║  ██║██║██╔╝ ██╗╚██████╔╝███████║"
echo "╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
echo -e "         \e[1;35m⚡ CYBER ANIME ENGINE ACTIVE ⚡\e[0m"
echo ""

UPTIME=$(uptime -p)
LOAD=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
KVER=$(uname -r)
IP_PRIV=$(hostname -I | awk '{print $1}')
IP_PUB=$(curl -s https://ifconfig.me || echo "Offline")
PING_RES=$(ping -c 2 8.8.8.8 2>/dev/null | tail -1 | awk -F '/' '{print $5 " ms"}')
[ -z "$PING_RES" ] && PING_RES="Timeout"

echo -e "\e[1;35m┌────────────────────────────────────────────────────────┐\e[0m"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "OS System" "NorixOS Server V2 (Ubuntu/Debian)"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "Kernel" "$KVER"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "Uptime" "$UPTIME"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "Load Avg" "$LOAD"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "Local IP" "$IP_PRIV"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "Public IP" "$IP_PUB"
printf " \e[1;36m%-12s\e[0m : %-40s \n" "Network Ping" "$PING_RES (8.8.8.8)"
echo -e "\e[1;35m└────────────────────────────────────────────────────────┘\e[0m"
echo ""
fastfetch
EOF
sudo chmod +x /etc/update-motd.d/99-norixos-motd

# 6. Thiết lập màn hình nhập lệnh Prompt Bo Góc & Đa Dòng
echo -e "${GREEN}[6/6] Định hình Starship Cyber Shell Prompt...${NC}"
mkdir -p ~/.config
cat << 'EOF' > ~/.config/starship.toml
format = """
┌── [🤖 \e[1;36mroot@NorixOS\e[0m] ── $directory$git_branch$git_status
└─ $character"""

add_newline = false

[directory]
style = "bold text_purple"
format = "[$path]($style) "
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bold cyan"
format = "on [$symbol$branch]($style) "

[character]
success_symbol = "══>\e[1;36m ❯\e[0m"
error_symbol = "══>\e[1;31m ❯\e[0m"
EOF

# Áp dụng thay đổi cho các file khởi tạo Shell
for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC_FILE" ]; then
        sed -i '/starship init/d' "$RC_FILE"
        sed -i '/alias nrx=/d' "$RC_FILE"
        echo 'eval "$(starship init bash)"' >> "$RC_FILE"
        echo "alias nrx='/usr/local/bin/nrx'" >> "$RC_FILE"
    fi
done

echo -e "${PURPLE}======================================================${NC}"
echo -e "${GREEN}  CẬP NHẬT LOGO HOÀN TẤT! HÃY KHỞI ĐỘNG LẠI SSH SESSION.${NC}"
echo -e "${PURPLE}======================================================${NC}"
