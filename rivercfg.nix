{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.rivercfg;
in {
  options.rivercfg = {
    enable = mkEnableOption "Window Manager Configuration";
    colors = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      default = null;
      description = ''
        Waybar color scheme
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      librewolf
      kitty
      alacritty
      kdePackages.dolphin
      wlogout
      wofi
      swayidle
      sway-audio-idle-inhibit
      libnotify
      wlr-randr
      grim
      slurp
      lxqt.qps
      libinput-gestures
      wl-clipboard
      river-filtile
      nautilus
    ];
    programs.alacritty.enable = true;
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = lib.mkForce "0.9";
      };
    };
    programs.ghostty = {
      enable = true;
    };
    wayland.windowManager.river = {
      enable = true;
      package = null;
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
        border-color-focused = lib.mkForce "0x8AADF4";
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = false;
      settings.mainBar = {
        layer = "top";
        position = "left";
        #height = 30;
        width = 30;
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
          tooltip-format = "{:%H:%M:%S}";
          format-alt = "{:%Y-%m-%d}";
          format = "{:%H:%M}";
          interval = 1;
        };
        "group/devices" = {
          orientation = "inherit";
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
          orientation = "inherit";
          drawer = {
          };
          modules = ["custom/infodrawer" "cpu" "memory" "temperature" "battery"];
        };
        cpu.format = "{usage}% ";
        memory.format = "{}% ";
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        battery = {
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon} 🗲";
          format-icons = ["" "" "" "" ""];
        };
        "custom/infodrawer" = {
          format = "󰮫";
        };
        "group/system" = {
          orientation = "inherit";
          modules = ["keyboard-state" "group/systray" "custom/power"];
        };
        "group/systray" = {
          orientation = "inherit";
          drawer = {
            transition-left-to-right = false;
          };
          modules = ["custom/trayopen" "tray"];
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = " {name}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        tray.icon-size = 20;
        tray.spacing = 5;
        "custom/trayopen" = {
          format = "󱊖";
        };
        "custom/power" = {
          format = "󰍃";
          on-click = "wlogout";
        };
      };
      style =
        mapNullable (theme: ''
                           * {
                               border: none;
                               border-radius: 0px;
                               font-family: "JetBrainsMono Nerd Font";
                               font-size: 13px;
                               min-height: 0;
                           }
                           @define-color base0 #${theme.base00};
                           @define-color base1 #${theme.base01};
                           @define-color base2 #${theme.base02};
                           @define-color base3 #${theme.base03};
                           @define-color base4 #${theme.base04};
                           @define-color base5 #${theme.base05};
                           @define-color base6 #${theme.base06};
                           @define-color base7 #${theme.base07};
                           @define-color base8 #${theme.base08};
                           @define-color base9 #${theme.base09};
                           @define-color baseA #${theme.base0A};
                           @define-color baseB #${theme.base0B};
                           @define-color baseC #${theme.base0C};
                           @define-color baseD #${theme.base0D};
                           @define-color baseE #${theme.base0E};
                           @define-color baseF #${theme.base0F};

                           @define-color text @base6;
                           @define-color accent @baseC;

                           window#waybar {
                               background-color: @base0;
                               color: @text;
                               transition-property: background-color;
                               transition-duration: .5s;
                           }

                           window#waybar.hidden {
                               opacity: 0.2;
                           }
                           #custom-launcher {
                               background-color: transparent;
                               color: @text;
                               font-size: 20px;
                           }

                           #tags {
                               background: transparent;
                           }
                           #tags button {
                               background: @base2;
                               color: #ffffff;
                               border-radius: 20px;
                               padding: 5px;
          margin-left: 10px;
          margin-right: 10px;
                               margin-top: 2px;
                               margin-bottom: 2px;
                               transition-property: all;
                          transition-duration: 0.2s;
                           }
                           #tags button.occupied {
                               background: @accent;
                           }
                           #tags button.focused {
                               padding-top: 15px;
                               padding-bottom: 15px;
                           }

                           #taskbar {
                               background-color: transparent;
                           }

                           #window {
                               background-color: transparent;
                               font-size: 15px;
                           }

                           #temperature,
                           #network,
                           #pulseaudio,
                           #custom-launcher,
                           #custom-power,
                    #custom-trayopen,
                    #custom-infodrawer,
                           #tray,
                           #idle_inhibitor {
                               padding-left: 10px;
                               padding-right: 10px;
                               color: @text;
                           }
                    #custom-trayopen, #custom-infodrawer {
                      font-size: 20px;
                    }

                           #clock {
                               color: @text;
                               background-color: transparent;
                           }

                           label:focus {
                               background-color: #000000;
                           }

                           #devices {
                               background-color: transparent;
                               color: @text;
                           }

                           #pulseaudio {
                               color: @text;
                               padding: 0px 5px;
                           }

                           #pulseaudio.muted {
                               color: @text;
                           }

                           #backlight {
                               color: @text;
                               padding: 0px 5px;
                           }
             #backlight-slider trough {
                min-width: 100px;
             }

                           #network {
                               color: @text;
                               padding: 0px 5px;
                           }

                           #network.disconnected {
                               color: red;
                           }

                           #monitor {
                               background-color: transparent;
                               color: @text;
                           }

                           #cpu {
                               padding: 0px 5px;
                           }

                           #memory {
                               padding: 0px 5px;
                           }

                           #temperature {
                               color: @text;
                               padding: 0px 5px;
                           }

                           #temperature.critical {
                               background-color: #eb4d4b;
                           }

                           #system {
                               background-color: transparent;
                               color: @text;
                           }

                           #keyboard-state {
                               min-width: 16px;
                           }

                           #keyboard-state > label {
                               padding: 0px 5px;
                           }

                           #keyboard-state > label.locked {
                               background: rgba(0, 0, 0, 0.2);
                           }

                           #tray {
                               color: black;
                           }

                           #tray > .passive {
                               -gtk-icon-effect: dim;
                               color: black;
                           }

                           #tray > .needs-attention {
                               -gtk-icon-effect: highlight;
                               color: black;
                           }

                           #custom-power{
                               font-size: 16px;
                               color: @text;
                           }
        '')
        cfg.colors;
    };
  };
}
