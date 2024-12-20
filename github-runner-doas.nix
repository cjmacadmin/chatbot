{ config, pkgs, lib, ... }:

with lib;

let
  # If you want to make this module more configurable,
  # you could define module options here.
in
{
  options = {
    services.github-runner-doas.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the github-runner-doas configuration.";
    };
  };

  config = mkIf config.services.github-runner-doas.enable {
    # Install doas
    environment.systemPackages = [
      pkgs.doas
    ];
  
    security.sudo.enable = true;
    security.wrappers.doas = {
      owner = "root";
      group = "root";
      source = "${pkgs.doas}/bin/doas";
      setuid = true;
    };

    # Configure doas permissions
    environment.etc."doas.conf".text = ''
      permit nopass github-runner as root cmd /run/current-system/sw/bin/cp
      permit nopass github-runner as root cmd /run/current-system/sw/bin/nixos-rebuild
    '';
  };
}