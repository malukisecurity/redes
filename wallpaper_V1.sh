#!/bin/bash
#--------------------------------------------------#
# Nome: Wallpaper_V1.sh                            #
# Criador: Welinton_dev                            #
# Data 07/05/2025                                  #
# Versão 0.0.0.1                                   #
# Descrição: Script serve parabloquear o wallpaper # # nos ambientes GNOME, KDE, XFCE, Cinnamon e MATE. #
#--------------------------------------------------#

WALLPAPER_PATH="/usr/share/backgrounds/imagem-fixa.jpg"

# Checa se o arquivo existe
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "O arquivo de wallpaper não foi encontrado em: $WALLPAPER_PATH"
    exit 1
fi

bloquear_wallpaper_gnome() {
    echo "Aplicando bloqueio de wallpaper no GNOME..."
    dconf write /org/gnome/desktop/background/picture-uri "'file://$WALLPAPER_PATH'"
    dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$WALLPAPER_PATH'"
    dconf lock /org/gnome/desktop/background/picture-uri
    dconf lock /org/gnome/desktop/background/picture-uri-dark
    echo "Wallpaper definido e bloqueado no GNOME."
}

bloquear_wallpaper_kde() {
    echo "Tentando aplicar o wallpaper no KDE Plasma..."
    CONFIG_DIR="$HOME/.config"
    PLASMA_CONFIG="$CONFIG_DIR/plasmashellrc"

    kwriteconfig5 --file "$PLASMA_CONFIG" --group "Containments" --key "wallpaperPlugin" "org.kde.image"
    kwriteconfig5 --file "$PLASMA_CONFIG" --group "Wallpaper" --key "Image" "$WALLPAPER_PATH"

    echo "Reiniciando a interface do Plasma (isso pode piscar a tela)..."
    pkill plasmashell && nohup plasmashell >/dev/null 2>&1 &
    echo "Wallpaper aplicado no KDE. Bloqueio total exige políticas adicionais."
}

bloquear_wallpaper_xfce() {
    echo "Configurando wallpaper no XFCE..."
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$WALLPAPER_PATH"
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 3

    CONFIG_FILE="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
    chmod a-w "$CONFIG_FILE" 2>/dev/null
    echo "Wallpaper configurado no XFCE. Arquivo de configuração protegido contra alterações."
}

bloquear_wallpaper_cinnamon() {
    echo "Configurando wallpaper no Cinnamon (Linux Mint)..."
    gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER_PATH"
    gsettings set org.cinnamon.desktop.background picture-options 'zoom'
    dconf lock /org/cinnamon/desktop/background/picture-uri
    echo "Wallpaper definido e bloqueado no Cinnamon."
}

bloquear_wallpaper_mate() {
    echo "Aplicando wallpaper no MATE (Linux Mint)..."
    gsettings set org.mate.background picture-filename "$WALLPAPER_PATH"
    gsettings set org.mate.background picture-options 'zoom'

    CONFIG_FILE="$HOME/.config/dconf/user"
    chmod a-w "$CONFIG_FILE" 2>/dev/null
    echo "Wallpaper definido no MATE. Arquivo de configuração protegido (bloqueio parcial)."
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
