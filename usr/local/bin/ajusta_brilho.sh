#!/usr/bin/env bash
#
# ========================================================================================
#
# Autor:         Fernando Souza https://github.com/tuxslack/ajusta_brilho / https://www.youtube.com/@fernandosuporte
# Data:          01/10/2025
# Versão:        0.2
# Script:        ajusta_brilho.sh
# Descrição:     
#
# Para aumentar ou diminuir o brilho da tela do seu monitor externo ou principal, 
#               
#                
#
# Uso:           
#  
# Para aumentar o brilho
#
# ajusta_brilho.sh up
#
#
# Para diminuir o brilho
#
# ajusta_brilho.sh down              
#
#
# Requisitos:    bash, xrandr, brightnessctl
# 
#
# ========================================================================================


# Instalação:

# sudo mv -i ajusta_brilho.sh /usr/local/bin/

# Dê permissão de execução:

# chmod +x /usr/local/bin/ajusta_brilho.sh


# ----------------------------------------------------------------------------------------

# Criar atalho de teclado


# 🖥️ XFCE

# Abra o gerenciador de configurações do XFCE:

# Vá no menu e procure por: Configurações → Teclado.

# Vá até a aba "Atalhos de Aplicativos".

# Clique no botão "Adicionar" (+)

# Digite o comando do script:

# Para aumentar o brilho:

# /usr/local/bin/ajusta_brilho.sh up

# Para diminuir o brilho:

# /usr/local/bin/ajusta_brilho.sh down

# ⚠️ Substitua seu_usuário pelo seu nome de usuário real.

# Depois de clicar em OK, o sistema vai pedir para você pressionar a combinação de teclas 
# desejada.

# Sugestão:

# Ctrl + Alt + ↑ para aumentar

# Ctrl + Alt + ↓ para diminuir

# Repita o processo para o segundo comando.

# ✅ Resultado:

# Agora, ao pressionar suas teclas de atalho, o script será executado, e o brilho da tela 
# será ajustado.



# 🖥️ i3wm / Sway

# Edite seu arquivo ~/.config/i3/config (ou do sway):

# Aumentar brilho
# bindsym $mod+Up exec /usr/local/bin/ajusta_brilho.sh up

# Diminuir brilho
# bindsym $mod+Down exec /usr/local/bin/ajusta_brilho.sh down


# Depois recarregue o i3 com Mod+Shift+R.

# ----------------------------------------------------------------------------------------

# ⚠️ Limitações:

# O ajuste de brilho via xrandr é software-based: ele escurece a imagem via software, mas 
# não altera o brilho real do hardware do monitor.

# Pode não funcionar corretamente com alguns drivers NVIDIA, dependendo da configuração 
# (modo NVIDIA, PRIME, etc).

# ----------------------------------------------------------------------------------------

clear


# Verifica se 'brightnessctl' está instalado

if ! command -v brightnessctl &> /dev/null; then

    echo -e "\nErro: 'brightnessctl' não encontrado.\n"

    exit 1
fi

# ----------------------------------------------------------------------------------------

# Detectar ambiente gráfico

SESSION_TYPE="${XDG_SESSION_TYPE}"

# ----------------------------------------------------------------------------------------

# Verifica se o argumento foi passado

if [ "$1" == "up" ]; then
    ACTION="up"
elif [ "$1" == "down" ]; then
    ACTION="down"
else
    echo "Uso: $0 {up|down}"
    exit 1
fi

# ----------------------------------------------------------------------------------------

# Função para ajustar brilho com xrandr (X11)

ajustar_brilho_x11() {

    OUTPUT=$(xrandr | grep " connected" | grep -v "disconnected" | awk '{print $1}' | head -n 1)

    if [ -z "$OUTPUT" ]; then
        echo -e "\nNenhuma saída de vídeo conectada foi detectada.\n"
        exit 1
    fi

    BRIGHTNESS=$(xrandr --verbose | grep -A 10 "^$OUTPUT" | grep -i brightness | awk '{print $2}')

    if [ "$ACTION" == "up" ]; then
        NEW_BRIGHTNESS=$(echo "$BRIGHTNESS + 0.1" | bc)
        if (( $(echo "$NEW_BRIGHTNESS > 1" | bc -l) )); then
            NEW_BRIGHTNESS=1
        fi
    elif [ "$ACTION" == "down" ]; then
        NEW_BRIGHTNESS=$(echo "$BRIGHTNESS - 0.1" | bc)
        if (( $(echo "$NEW_BRIGHTNESS < 0.1" | bc -l) )); then
            NEW_BRIGHTNESS=0.1
        fi
    fi

    xrandr --output "$OUTPUT" --brightness "$NEW_BRIGHTNESS"
}

# ----------------------------------------------------------------------------------------

# Função para testar se precisamos de sudo com brightnessctl

# O brightnessctl pode exigir sudo, dependendo de como os permissões dos arquivos de 
# controle de brilho estão configuradas no seu sistema.

precisa_sudo_brightnessctl() {

    brightnessctl --quiet info &>/dev/null
    if [ $? -ne 0 ]; then
        return 0  # precisa de sudo
    else
        return 1  # não precisa de sudo
    fi
}

# ----------------------------------------------------------------------------------------

# Função para ajustar brilho com brightnessctl (Wayland ou X11)

ajustar_brilho_brightnessctl() {

    if precisa_sudo_brightnessctl; then
        CMD="sudo brightnessctl"
    else
        CMD="brightnessctl"
    fi

    if [ "$ACTION" == "up" ]; then
        $CMD set +10%
    elif [ "$ACTION" == "down" ]; then
        $CMD set 10%-
    fi
}

# ----------------------------------------------------------------------------------------

# Lógica principal

if [ "$SESSION_TYPE" == "x11" ]; then

    if command -v xrandr &> /dev/null; then
        ajustar_brilho_x11
    else
        ajustar_brilho_brightnessctl
    fi

elif [ "$SESSION_TYPE" == "wayland" ]; then
    ajustar_brilho_brightnessctl

else

    echo -e "\nNão foi possível detectar o tipo de sessão gráfica.\n"

    exit 1
fi

# ----------------------------------------------------------------------------------------

exit 0
