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
    grim
    slurp
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
      homedeploy = "alejandra ~/Config/home-manager && home-manager switch";
    };
    history.size = 1000000;
    history.path = "/home/kit/Config/zsh/history";
    initExtra = ''
      source ~/.p10k.zsh
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    '';
  };
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "macchiato";
      };
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.8;
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
            "Super F" = "spawn thunar";
            "Super W" = "spawn librewolf";
            "Super+Shift E" = "spawn wlogout";
            "Super Space" = "spawn 'rofi -show drun'";
            "Super+Shift Space" = "toggle-float";
            "Super Tab" = "zoom";
            "Super O" = "send-to-output next";
            "Super Minus" = "send-layout-cmd rivertile 'main-ratio -0.05'";
            "Super Equal" = "send-layout-cmd rivertile 'main-ratio +0.05'";
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
        "lid close" = "spawn 'systemctl suspend'"
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
    systemd.target = "hyprland-session.target";
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

  wayland.windowManager.hyprland = {
    enable = false;
    settings = {
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
      bind = let
        workspaces = [
          1
          2
          3
          4
          5
          6
          7
          8
          9
          10
        ];
        directions = {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
        };
      in
        [
          "SUPER,Q,killactive"
          "SUPER_SHIFT,E,exec,wlogout"
          "SUPER,Space,exec,rofi -show drun"

          "SUPER,Return,exec,kitty"
          "SUPER,F,exec,thunar"
          "SUPER,W,exec,librewolf"

          "SUPER_SHIFT,Space,togglefloating"
          "SUPER,Tab,cyclenext"
          "SUPER_SHIFT,Tab,exec,screenshot-helper"
          "SUPER,S,exec,wallpaper-swap 1 wipe"
          "SUPER_SHIFT,S,exec,wallpaper-swap -1 wipe"
          "SUPER_SHIFT,F,fullscreen,0"

          ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_SINK@ 5%+"
          ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_SINK@ 5%-"
        ]
        ++ (lib.mapAttrsToList (
            key: dir: "SUPER,${key},movefocus,${dir}"
          )
          directions)
        ++ (lib.mapAttrsToList (
            key: dir: "SUPER_SHIFT,${key},movewindow,${dir}"
          )
          directions)
        ++ (map (
            key: "SUPER,${
              if key > 9
              then toString 0
              else toString key
            },workspace,${toString key}"
          )
          workspaces)
        ++ (map (
            key: "SUPER_SHIFT,${
              if key > 9
              then toString 0
              else toString key
            },movetoworkspacesilent,${toString key}"
          )
          workspaces);
      general.gaps_in = 10;
      general.gaps_out = 10;
      general.border_size = 5;
      general."col.active_border" = "rgb(8aadf4)";
      decoration = {
        rounding = 15;
        blur.enabled = true;
        blur.size = 3;
        blur.passes = 3;
        blur.new_optimizations = true;
      };
      animations.enabled = true;
      animations.animation = [
        "windows,1,3,default,popin"
        "workspaces,1,3,default,slidevert"
      ];
      monitor = [
        "eDP-1,preferred,1920x0,1"
        "DP-3,preferred,0x1080,1"
      ];
      workspace = let
        primaryspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
        ];
        secondaryspaces = [
          "6"
          "7"
          "8"
          "9"
          "10"
        ];
      in
        []
        ++ (map (prispace: "${prispace},monitor:eDP-1") primaryspaces)
        ++ (map (secspace: "${secspace},monitor:DP-3") secondaryspaces);
    };
  };
  home.stateVersion = "23.11";
}
