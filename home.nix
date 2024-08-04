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
    river-filtile
    nautilus
    zed-editor
    ghc
    mdbook
    jetbrains.rust-rover
  ];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    initExtraBeforeCompInit = ''
      eval "$(oh-my-posh init zsh)"
    '';
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    antidote.enable = true;
    antidote.plugins = [
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
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    '';
  };
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      blocks = [
        {
          alignment = "right";
          type = "rprompt";
          segments = [
            {
              style = "diamond";
              type = "os";
              trailing_diamond = "";
              leading_diamond = "";
              template = "{{.Icon}} ";
              background = "8";
              foreground = "15";
            }
            {
              type = "executiontime";
              style = "powerline";
              powerline_symbol = "";
              background = "8";
              foreground = "15";
              template = "{{ .FormattedMs }}";
              properties = {
                threshold = "0";
                style = "austin";
                always_enabled = true;
              };
            }
            {
              type = "rust";
              style = "powerline";
              powerline_symbol = "";
              background = "8";
              foreground = "15";
              template = "{{ .Full }}";
            }
          ];
        }
        {
          alignment = "left";
          type = "prompt";
          segments = [
            {
              style = "diamond";
              trailing_diamond = "";
              leading_diamond = "";
              background = "8";
              foreground = "15";
              properties = {
                folder_icon = " ";
                folder_separator_icon = "  ";
                max_depth = 1;
                style = "agnoster_short";
              };
              template = "{{ .Path }}";
              type = "path";
            }
            {
              type = "git";
              style = "powerline";
              powerline_symbol = "";
              background = "8";
              foreground = "15";
              template = "{{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }}";
              properties = {
                fetch_status = true;
                fetch_upstream_icon = true;
              };
            }
          ];
        }
      ];
      transient_prompt = {
        foreground = "8";
        template = "██";
      };
    };
  };
  stylix.enable = true;
  stylix.image = ./wpaper.jpg;
  stylix.base16Scheme = {
    base00 = "24283B";
    base01 = "16161E";
    base02 = "343A52";
    base03 = "444B6A";
    base04 = "787C99";
    base05 = "A9B1D6";
    base06 = "CBCCD1";
    base07 = "D5D6DB";
    base08 = "C0CAF5";
    base09 = "A9B1D6";
    base0A = "0DB9D7";
    base0B = "9ECE6A";
    base0C = "B4F9F8";
    base0D = "2AC3DE";
    base0E = "BB9AF7";
    base0F = "F7768E";
  };
  stylix.targets.waybar.enable = false;
  stylix.targets.gtk.extraCss = ''
        /* No (default) title bar on wayland */
    headerbar.default-decoration {
      /* You may need to tweak these values depending on your GTK theme */
      margin-bottom: 50px;
      margin-top: -100px;
    }

    /* rm -rf window shadows */
    window.csd,             /* gtk4? */
    window.csd decoration { /* gtk3 */
      box-shadow: none;
    }
  '';
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
  programs.alacritty.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.9";
    };
  };
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
            "Super F" = "spawn 'nautilus -w'";
            "Super W" = "spawn librewolf";
            "Super+Shift E" = "spawn wlogout";
            "Super Space" = "spawn 'rofi -show drun'";
            "Super+Shift Space" = "toggle-float";
            "Super Tab" = "zoom";
            "Super O" = "send-to-output next";
            "Super Minus" = "send-layout-cmd filtile 'main-ratio -0.05'";
            "Super Equal" = "send-layout-cmd filtile 'main-ratio +0.05'";
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
        "filtile"
        "'tag set-view-tags 1'"
        "'wlr-randr --output eDP-1 --pos 1920,0'"
        "'wlr-randr --output DP-3 --pos 0,1080'"
        "'swayidle timeout 600 systemctl suspend'"
        "'sway-audio-idle-inhibit'"
        "libinput-gestures"
      ];
      default-layout = "filtile";
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

      modules-left = ["custom/launcher" "river/tags" "wlr/taskbar"];
      modules-center = ["clock"];
      modules-right = ["group/devices" "group/monitor" "group/system"];
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
