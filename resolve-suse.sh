#!/bin/sh
# vars
file=""
run=""
dir="$(dirname "$(realpath "$0")")"
# func
get_lang() {
    local lang="${LANG:0:2}"
    local available=("pt")
    if [[ " ${available[*]} " == *"$lang"* ]]; then
        ulang="$lang"
    else
        ulang="en"
    fi
    if [ $ulang == "pt" ]; then
        source ./langs/pt
    else
        source ./langs/en
    fi
}
deps () {
    sudo zypper addrepo https://download.opensuse.org/repositories/home:frispete:Tumbleweed/openSUSE_Tumbleweed/home:frispete:Tumbleweed.repo
    sudo zypper refresh
    sudo zypper in --non-interactive libxcb-dri2-0 libxcb-dri2-0-32bit libgthread-2_0-0 libgthread-2_0-0-32bit libapr1 libapr-util1
}
install () {
    unzip $file
    ./"$run"
    if [ $? -eq 0 ]; then
        cd /opt/resolve/libs
        sudo mkdir disabled
        sudo mv libglib* disabled
        sudo mv libgio* disabled
        sudo mv libgmodule* disabled
    else
        echo $cancelled
        sleep 5
        exit 2
    fi
}
version () {
    echo $versionpick
    echo "1) Free"
    echo "2) Studio"
    read -p "1/2: " choice
    case "$choice" in
        1)
            file="DaVinci_Resolve_19.1.3_Linux.zip"
            run="DaVinci_Resolve_19.1.3_Linux.run";;
        2) 
            file="DaVinci_Resolve_Studio_19.1.3_Linux.zip"
            run="DaVinci_Resolve_Studio_19.1.3_Linux.run";;
        *)
            echo $cancelled
            sleep 5
            exit 2;;
    esac
} 
# runtime
get_lang
if command -v "zypper" &> /dev/null; then
    echo $start
else
    echo $incompat
    sleep 5
    exit 1
fi
version
if [[ -f "$dir/$file" ]]; then
    deps
    install
else
    echo $missing
    sleep 5
    exit 3
fi
echo $success
sleep 5
exit 0