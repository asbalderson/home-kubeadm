function disable_swap() {
    set -uex
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
}
