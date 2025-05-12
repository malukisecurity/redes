#!/bin/bash
#--------------------------------------#
# Nome: Wallpaper_V2.sh                #
# Criador: Welinton_dev                #
# Data 07/05/2025                      #
# Versão 0.0.0.2                       #
# Descrição: Script para definir       #
# e bloquear o wallpaper nos ambientes #
# GNOME, KDE, XFCE, Cinnamon e MATE.   #
#--------------------------------------#

# Solicita o caminho da imagem
read -e -p "Informe o caminho completo da imagem que deseja usar como wallpaper: " WALLPAPER_PATH
WALLPAPER_PATH=$(echo "$WALLPAPER_PATH" | sed "s/^['\"]//;s/['\"]$//")

# Verifica se o caminho é válido
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Erro: Arquivo não encontrado em $WALLPAPER_PATH"
    exit 1
fi

bloquear_wallpaper_gnome() {
    echo "[GNOME] Bloqueando wallpaper..."
    dconf write /org/gnome/desktop/background/picture-uri "'file://$WALLPAPER_PATH'"
    dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$WALLPAPER_PATH'"
    dconf lock /org/gnome/desktop/background/picture-uri
    dconf lock /org/gnome/desktop/background/picture-uri-dark
    echo "Wallpaper definido e bloqueado no GNOME."
}

bloquear_wallpaper_kde() {
    echo "[KDE Plasma] Aplicando wallpaper..."
    CONFIG_DIR="$HOME/.config"
    PLASMA_CONFIG="$CONFIG_DIR/plasmashellrc"

    kwriteconfig5 --file "$PLASMA_CONFIG" --group "Containments" --key "wallpaperPlugin" "org.kde.image"
    kwriteconfig5 --file "$PLASMA_CONFIG" --group "Wallpaper" --key "Image" "$WALLPAPER_PATH"

    echo "Reiniciando o Plasma (tela pode piscar)..."
    pkill plasmashell && nohup plasmashell >/dev/null 2>&1 &
    echo "Wallpaper aplicado no KDE. Bloqueio completo exige configurações extras."
}

bloquear_wallpaper_xfce() {
    echo "[XFCE] Definindo wallpaper..."
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$WALLPAPER_PATH"
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 3

    CONFIG_FILE="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
    chmod a-w "$CONFIG_FILE" 2>/dev/null
    echo "Wallpaper definido e arquivo protegido contra alterações."
}

bloquear_wallpaper_cinnamon() {
    echo "[Cinnamon] Aplicando wallpaper..."
    gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER_PATH"
    gsettings set org.cinnamon.desktop.background picture-options 'zoom'
    dconf lock /org/cinnamon/desktop/background/picture-uri
    echo "Wallpaper definido e bloqueado no Cinnamon."
}

bloquear_wallpaper_mate() {
    echo "[MATE] Aplicando wallpaper..."
    gsettings set org.mate.background picture-filename "$WALLPAPER_PATH"
    gsettings set org.mate.background picture-options 'zoom'

    CONFIG_FILE="$HOME/.config/dconf/user"
    chmod a-w "$CONFIG_FILE" 2>/dev/null
    echo "Wallpaper definido no MATE. Arquivo dconf protegido (bloqueio parcial)."
}

mostrar_menu() {
    clear
    echo "======================================"
    echo "     BLOQUEADOR DE WALLPAPER LINUX    "
    echo "======================================"
    echo "1) GNOME"
    echo "2) KDE Plasma"
    echo "3) XFCE"
    echo "4) Cinnamon (Linux Mint)"
    echo "5) MATE (Linux Mint)"
    echo "6) Sair"
    echo "--------------------------------------"
    read -p "Escolha o ambiente gráfico (1-6): " opcao
}

while true; do
    mostrar_menu
    case $opcao in
        1) bloquear_wallpaper_gnome ;;
        2) bloquear_wallpaper_kde ;;
        3) bloquear_wallpaper_xfce ;;
        4) bloquear_wallpaper_cinnamon ;;
        5) bloquear_wallpaper_mate ;;
        6) echo "Encerrando script."; exit 0 ;;
        *) echo "Opção inválida."; sleep 2 ;;
    esac
    read -p "Pressione Enter para voltar ao menu..."
done
