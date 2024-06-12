{
  pkgs,
  lib,
  ...
}: {
  home.username = "kit";
  home.homeDirectory = "/home/kit";
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    obsidian
    librewolf
    kate
    kitty
    blender
    alacritty
    _1password-gui
    webcord
    clang
    fastfetch
    kdePackages.dolphin
    dolphin-emu
    wlogout
    tiramisu
    swayidle
    sway-audio-idle-inhibit
    libnotify
    alejandra
    nil
    prismlauncher
    wlr-randr
    libinput-gestures
    grim
    slurp
    zotero
    lxqt.qps
    wl-clipboard
    libresprite
  ];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      local P10K_INSTANT_PROMPT="~/Cache/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    antidote.enable = true;
    antidote.plugins = [
      "romkatv/powerlevel10k"
      "chisui/zsh-nix-shell"
    ];
    shellAliases = {
      sysconf = "doas nvim /etc/nixos/configuration.nix";
      hwconf = "doas nvim /etc/nixos/hardware-configuration.nix";
      sysdeploy = "doas alejandra /etc/nixos && doas nixos-rebuild switch";
      sysflake = "doas nvim /etc/nixos/flake.nix";
      sysupgrade = "doas nixos-rebuild switch --upgrade";

      shell = "zsh ~/scripts/quicknix.sh";

      homeconf = "nvim ~/Config/home-manager/home.nix";
      homeflake = "nvim ~/Config/home-manager/flake.nix";
      homepull = "cd ~/Config/home-manager && git pull && cd -";
      homepush = "cd ~/Config/home-manager && git push && cd -";
      homedeploy = "alejandra ~/Config/home-manager && home-manager switch";
    };
    history.size = 1000000;
    history.path = "/home/kit/Config/zsh/history";
    initExtra = ''
      source ~/.p10k.zsh
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    '';
  };
  #gtk = {
  #  enable = true;
  #  theme = {
  #    name = "Catppuccin-Macchiato-Standard-Blue-Dark";
  #    package = pkgs.catppuccin-gtk.override {
  #      variant = "macchiato";
  #    };
  #  };
  #};
  stylix.enable = true;
  stylix.image = ./wpaper.jpg;
  stylix.base16Scheme = {
    base00 = "24273a"; # base
    base01 = "1e2030"; # mantle
    base02 = "363a4f"; # surface0
    base03 = "494d64"; # surface1
    base04 = "5b6078"; # surface2
    base05 = "cad3f5"; # text
    base06 = "f4dbd6"; # rosewater
    base07 = "b7bdf8"; # lavender
    base08 = "ed8796"; # red
    base09 = "f5a97f"; # peach
    base0A = "eed49f"; # yellow
    base0B = "a6da95"; # green
    base0C = "8bd5ca"; # teal
    base0D = "8aadf4"; # blue
    base0E = "c6a0f6"; # mauve
    base0F = "f0c6c6"; # flamingo
  };
  stylix.targets.waybar.enable = false;
  stylix.targets.vim.enable = false;
  stylix.cursor.package = pkgs.kdePackages.breeze;
  stylix.cursor.name = "breeze_cursors";
  stylix.fonts = let
    allfonts = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts;
    };
  in {
    monospace = allfonts;
    sansSerif = allfonts;
    serif = allfonts;
  };
  #programs.alacritty = {
  #  enable = true;
  #  settings = {
  #    window.opacity = 0.8;
  #  };
  #};
  programs.home-manager.enable = true;
  wayland.windowManager.river = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      map = let
        workspaces = ["1" "2" "3" "4" "5"];
      in {
        normal =
          {
            "Super Return" = "spawn kitty";
            "Super Q" = "close";
            "Super F" = "spawn thunar";
            "Super W" = "spawn librewolf";
            "Super+Shift E" = "spawn wlogout";
            "Super Space" = "spawn 'rofi -show drun'";
            "Super+Shift Space" = "toggle-float";
            "Super Tab" = "zoom";
            "Super O" = "send-to-output next";
            "Super Minus" = "send-layout-cmd rivertile 'main-ratio -0.05'";
            "Super Equal" = "send-layout-cmd rivertile 'main-ratio +0.05'";
            "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_SINK@ 5%+'";
            "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_SINK@ 5%-'";
          }
          // builtins.listToAttrs (map (ws: {
              name = "Alt ${ws}";
              value = "spawn 'tag toggle-focused-tags ${ws}'";
            })
            workspaces)
          // builtins.listToAttrs (map (ws: {
              name = "Alt+Shift ${ws}";
              value = "spawn 'tag toggle-view-tags ${ws}'";
            })
            workspaces)
          // builtins.listToAttrs (map (ws: {
              name = "Super ${ws}";
              value = "spawn 'tag set-focused-tags ${ws}'";
            })
            workspaces)
          // builtins.listToAttrs (map (ws: {
              name = "Super+Shift ${ws}";
              value = "spawn 'tag set-view-tags ${ws}'";
            })
            workspaces);
      };
      map-switch.normal = {
        "lid close" = "spawn 'systemctl suspend'";
      };
      map-pointer = {
        normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";
        };
      };
      spawn = [
        "'swww init'"
        "waybar"
        "rivertile"
        "'tag set-view-tags 1'"
        "'wlr-randr --output eDP-1 --pos 1920,0'"
        "'wlr-randr --output DP-3 --pos 0,1080'"
        "'swayidle timeout 600 systemctl suspend'"
        "'sway-audio-idle-inhibit'"
        "libinput-gestures"
      ];
      default-layout = "rivertile";
      focus-follows-cursor = "always";
      border-width = 5;
      border-color-focused = "0x8AADF4";
    };
  };
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 0;
      margin-top = 0;
      margin-bottom = 0;

      modules-left = ["custom/launcher" "group/r-launcher" "group/l-workspaces" "river/tags" "group/r-workspaces" "group/l-taskbar" "wlr/taskbar" "group/r-taskbar"];
      modules-center = ["group/l-clock" "clock" "group/r-clock"];
      modules-right = ["group/l-devices" "group/devices" "group/r-devices" "group/l-monitor" "group/monitor" "group/r-monitor" "group/l-system" "group/system"];
      "custom/launcher" = {
        format = " ";
        on-click = "rofi -show drun";
      };
      "river/tags" = {
        num-tags = 5;
        tag-labels = ["" "" "" "" ""];
      };
      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 20;
        spacing = 5;
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
        format = "{:%H:%M:%S}";
        interval = 1;
      };
      "group/devices" = {
        orientation = "horizontal";
        modules = ["pulseaudio" "backlight" "network"];
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "";
        format-icons = ["" "" ""];
      };
      backlight = {
        format = "{percent}% {icon}";
        format-icons = ["" "󰃠"];
      };
      network = {
        format-wifi = "{signalStrength}%  ";
      };
      "group/monitor" = {
        orientation = "horizontal";
        modules = ["cpu" "memory" "temperature" "battery"];
      };
      cpu.format = "{usage}%  ";
      memory.format = "{}%  ";
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = ["" "" ""];
      };
      battery = {
        full-at = 65;
        format = "{capacity}% {icon}  ";
        format-charging = "{capacity}% {icon} 󱐌  ";
        format-icons = ["" "" "" "" ""];
      };
      "group/system" = {
        orientation = "horizontal";
        modules = ["keyboard-state" "tray" "custom/power"];
      };
      keyboard-state = {
        numlock = true;
        capslock = true;
        format = " {name} {icon}";
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };
      tray.icon-size = 20;
      tray.spacing = 5;
      "custom/power" = {
        format = "󰍃";
        on-click = "wlogout";
      };
    };
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp_luasnip
      cmp-nvim-lsp
    ];
  };
  home.stateVersion = "23.11";
}
