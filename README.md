# ajusta_brilho
Para aumentar ou diminuir o brilho da tela do seu monitor externo ou principal.


Criar atalho de teclado


🖥️ XFCE

Abra o gerenciador de configurações do XFCE:

Vá no menu e procure por: Configurações → Teclado.

Vá até a aba "Atalhos de Aplicativos".

Clique no botão "Adicionar" (+)

Digite o comando do script:

Para aumentar o brilho:

/usr/local/bin/ajusta_brilho.sh up

Para diminuir o brilho:

/usr/local/bin/ajusta_brilho.sh down

Depois de clicar em OK, o sistema vai pedir para você pressionar a combinação de teclas 
desejada.

Sugestão:

Ctrl + Alt + ↑ para aumentar

Ctrl + Alt + ↓ para diminuir

Repita o processo para o segundo comando.

✅ Resultado:

Agora, ao pressionar suas teclas de atalho, o script será executado, e o brilho da tela 
será ajustado.



🖥️ i3wm / Sway

Edite seu arquivo ~/.config/i3/config (ou do sway):

Aumentar brilho
bindsym $mod+Up exec /usr/local/bin/ajusta_brilho.sh up

Diminuir brilho
bindsym $mod+Down exec /usr/local/bin/ajusta_brilho.sh down


Depois recarregue o i3 com Mod+Shift+R.



⚠️ Limitações:

O ajuste de brilho via xrandr é software-based: ele escurece a imagem via software, mas 
não altera o brilho real do hardware do monitor.

Pode não funcionar corretamente com alguns drivers NVIDIA, dependendo da configuração 
(modo NVIDIA, PRIME, etc).
