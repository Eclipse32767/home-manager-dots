{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    fastfetch
    alejandra
    nil
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

      homepull = "cd ~/Config/home-manager && git pull && cd -";
      homepush = "cd ~/Config/home-manager && git push && cd -";
      homedeploy = "alejandra ~/Config/home-manager && home-manager switch";
    };
    history.size = 1000000;
    history.path = "/home/kit/Config/zsh/history";
    initExtra = ''
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      homeconf() {
      	nvim ~/Config/home-manager/$1
      }
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
}
