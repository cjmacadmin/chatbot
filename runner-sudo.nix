{ config, pkgs, lib, ... }:

with lib;

let
  # If you want to make this module more configurable,
  # you could define module options here.
in
{
  options = {
    services.github-runner-sudo.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the github-runner sudo configuration.";
    };
  };

  config = mkIf config.services.github-runner-sudo.enable {
    # Enable sudo
    security.sudo.enable = true;

    # Configure sudo permissions
    security.sudo.extraRules = [
      {
        users = [ "github-runner" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/cp";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    # Add container-friendly sudo configuration
    security.sudo.extraConfig = ''
      Defaults!ALL setenv
      Defaults!/run/current-system/sw/bin/cp env_keep+=NO_NEW_PRIVS
      Defaults!/run/current-system/sw/bin/nixos-rebuild env_keep+=NO_NEW_PRIVS
    '';
  };
}
