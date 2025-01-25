function ssh_func() {
    ssh ubuntu@$1 "$(typeset -f $2); $2 ${@:3}"
}
