# omarchy-stickynote

Um checknoter flutuante e nativo pro Omarchy/Hyprland. Um quadradinho amarelo
estilo post-it: digite no topo, dê **Enter** e vira um item com checkbox.
Marcou o checkbox → o item some. Dados salvos localmente na hora.

- **Nativo**: GTK4 (Python + PyGObject), sem Electron, abre instantâneo.
- **Flutuante normal**: abre no workspace atual, **não escurece a tela** e não
  bloqueia o foco, os cliques ou os atalhos dos outros tiles. Nasce fora do tile
  manager sem mexer no seu `SUPER+G`.
- **Sobe/desce**: `SUPER + CTRL + S` faz toggle (ou clique no ícone do waybar).
- **Ícone no tray do waybar**: recolhido junto dos ícones como o Slack, mostra o
  nº de notas pendentes; clique faz toggle; o app atualiza via SIGRTMIN+11.
- **Persistência**: `~/.local/share/omarchy-stickynote/notes.json` (escrita atômica).
- **Esc**: esconde a nota.
- **Multilinha**: `Shift+Enter` quebra a linha; `Enter` cria a nota.
- **Feedback visual**: entrada suave e explosão de sparkles no checkbox ao concluir.

## Instalar

### Arch Linux / Omarchy (AUR)

```bash
yay -S omarchy-stickynote
```

Depois da instalação, pressione `SUPER + SPACE` e procure por **Sticky Notes**.
O pacote instala a entrada XDG em `/usr/share/applications`, então também
funciona em outros launchers compatíveis.

### Release manual

Baixe `omarchy-stickynote-1.0.0.tar.gz` na página de releases, extraia e rode:

```bash
./install.sh
```

### Desenvolvimento local

```bash
git clone https://github.com/Christopher-Moreira/omarchy-stickynote.git
cd omarchy-stickynote
./install.sh
```

Isso linka os três executáveis em `~/.local/bin` e instala a entrada `.desktop`
e o ícone em `~/.local/share`, tornando o app pesquisável imediatamente.

## Configurar o Hyprland

**`~/.config/hypr/hyprland.conf`** (no final — window rules pessoais):

```conf
windowrule = float on,                        match:class ^com\.omarchy\.stickynote$
windowrule = size 360 440,                    match:class ^com\.omarchy\.stickynote$
windowrule = move (monitor_w-window_w-24) 24, match:class ^com\.omarchy\.stickynote$
windowrule = rounding 16,                     match:class ^com\.omarchy\.stickynote$
windowrule = opacity 1 1,                     match:class ^com\.omarchy\.stickynote$
```

**`~/.config/hypr/bindings.conf`** (`SUPER+CTRL+S` é "Share" por padrão):

```conf
unbind = SUPER CTRL, S
bindd = SUPER CTRL, S, Sticky note, exec, omarchy-stickynote-toggle
```

**`~/.config/hypr/autostart.conf`** (residente, escondido, no login):

```conf
exec-once = uwsm-app -- ~/.local/bin/omarchy-stickynote --hidden
```

Depois: `hyprctl reload`.

## Configurar o Waybar

Em `~/.config/waybar/config.jsonc`, adicione o módulo e coloque-o dentro do
`group/tray-expander`, junto ao tray:

```jsonc
"custom/stickynote": {
  "exec": "~/.local/bin/omarchy-stickynote-waybar",
  "return-type": "json",
  "interval": 3600,
  "signal": 11,
  "on-click": "~/.local/bin/omarchy-stickynote-toggle",
  "tooltip": true
}
```

```jsonc
"group/tray-expander": {
  "modules": ["custom/expand-icon", "custom/stickynote", "tray"]
}
```

CSS opcional em `~/.config/waybar/style.css`:

```css
#custom-stickynote { min-width: 12px; margin: 0 7.5px; }
#custom-stickynote.empty { opacity: 0.55; }
```

Depois: `omarchy restart waybar`.

## Uso

- `SUPER + SPACE`, procure **Sticky Notes** — abre pelo launcher
- `SUPER + CTRL + S` ou clique no ícone do waybar — sobe/desce
- Digite + `Enter` — adiciona item
- `Shift + Enter` — quebra linha sem criar outro item
- Clique no checkbox (ou no texto) — conclui e remove
- `Esc` — esconde

## Linha de comando

```
omarchy-stickynote            abre (mostra)
omarchy-stickynote --hidden   residente, escondido (autostart)
omarchy-stickynote --toggle   mostra/esconde a instância em execução
omarchy-stickynote --show / --hide
```

## Desenvolvimento e release

```bash
make test
make dist VERSION=1.0.0
```

O arquivo `packaging/aur/PKGBUILD` contém a receita do pacote Arch/AUR. Releases
usam tags `vX.Y.Z` e o tarball determinístico criado por `make dist`.

## Licença

[MIT](LICENSE) © 2026 Christopher Moreira.
