{ config, lib, pkgs, ... }:
{ 
  services.github-runners = {
#     runner = {
#       enable = true;
#       url = "https://github.com/tylercote/gnc-telegram-bot";
#       tokenFile = "/etc/gnc_bot/github_token";
#       replace = true;
#       extraLabels = [ "nixos" "self-hosted" ];
      
#       # Configure the runner environment
#       serviceOverrides = {
#         User = "github-runner";
#         WorkingDirectory = lib.mkForce "/var/lib/github-runner";
#       };

#       # Runner configuration
#       extraPackages = with pkgs; [
#         # Common build tools
#         git
#         nixFlakes
#         curl
#         wget
#         gnumake
#         gcc
#         docker
#         docker-compose
#         docker-buildx
#       ];
#     };

    nixedit = {
      enable = true;
      url = "https://github.com/cjmacadmin/chatbot";
      tokenFile = "/etc/runners/github_token";
      replace = true;
      extraLabels = [ "nixos" "self-hosted" ];
      # Configure the runner environment
      serviceOverrides = {
        User = "github-runner";
        WorkingDirectory = lib.mkForce "/var/lib/github-runner";
      };

      # Runner configuration
      extraPackages = with pkgs; [
        # Common build tools
        git
        nixFlakes
        curl
        wget
        gnumake
        gcc
        docker
        docker-compose
        docker-buildx
      ];
    };
  };
  # Create the runner user
  users.users.github-runner = {
    isSystemUser = true;
    group = "github-runner";
    home = "/var/lib/github-runner";
    shell = pkgs.bash;
    createHome = true;
  };

  users.groups.github-runner = {};

  # Ensure the runner has access to nix commands
  nix.settings = {
    trusted-users = [ "github-runner" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow the runner to access the network
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };

}