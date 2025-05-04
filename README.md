# 🧠 Neovim Ultra AI Edition (C#, Vue, LazyGit, AI, Zen, Everything)

Добродошао у свој најмоћнији Neovim сетап досад.  
Ово је спремно за:

- ✅ .NET (C#) + OmniSharp (csharp-ls)
- ✅ Vue.js (Volar + TS + TS Server)
- ✅ TailwindCSS + Tailwind Color Preview
- ✅ LazyGit
- ✅ Copilot AI сугестије
- ✅ ChatGPT интеграцију
- ✅ Zen Mode (фокус на кодирању)
- ✅ Prettier + CSharpier formatting
- ✅ Dashboard, Harpoon, Noice, Trouble, Lualine...
- ✅ FiraCode Nerd Font (због иконица и лепоте)

---

## 📦 Инсталација

```bash
git clone https://github.com/tvojuser/neovim-ultra-ai.git
cd neovim-ultra-ai
chmod +x install.sh
./install.sh
```

Све ће бити инсталирано:

- Neovim + Plugins
- Packer
- LazyGit
- NodeJS + NPM глобални пакети (Volar, TypeScript LS)
- .NET csharp-ls (LSP сервер)
- FiraCode Nerd Font
- Све потребно за autocomplete, snippets, AI, форматирање и лепоту

---

## 🚀 Стартовање

Када се све инсталира:

```bash
nvim
```

Први пут уради:

```
:PackerSync
```

и plugins ће бити преузети.

---

## ⚙️ Додатне напомене

- **CTRL + SPACE** → Autocomplete popup (свуда)
- **Tab** → Прихвати Copilot AI предлог
- **CTRL + l** → Copilot accept (такође ради ако желиш)
- **LazyGit** → `:LazyGit` команда унутар Neovim-а
- **Zen Mode** → `:ZenMode` да искључиш све осим кода
- **ChatGPT** → `<leader>ai` отвори ChatGPT прозор

---

## 🛠️ Захтеви

- Fedora (али може лако и на Arch/Debian, само променити пакет менаџер)
- Neovim (инсталирано скриптом)
- dotnet-sdk (инсталирано скриптом)
- nodejs/npm (инсталирано скриптом)
- git, curl, ripgrep (инсталирано скриптом)

---

## 📢 Напомена

- Ако не ради dotnet LSP → рестартуј терминал (PATH ће бити додат)
- За најбоље искуство, користи Nerd Font терминал (инсталира се скриптом)
- За GNOME и Kitty терминал ради без проблема → Ctrl+Space је активан

---

## 📌 TODO за будућност

- [ ] Flatpak подршка
- [ ] Linux ARM/Android Termux верзија
- [ ] Windows верзија (ако баш морамо 🤣)

---

## ❤️ Захвалнице

Овај сетап је састављен у сарадњи са **Ultra AI Burke Edition** и наравно, уз много живаца 😄
