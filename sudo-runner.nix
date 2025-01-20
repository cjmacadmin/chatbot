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
    security.sudo.extraRules = [{
      users = [ "github-runner" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" "SETENV" ];
      }];
    }];

    # Add container-friendly sudo configuration
    security.sudo.extraConfig = ''
      Defaults!ALL setenv
      Defaults!ALL env_keep+="PATH"
      Defaults!/run/current-system/sw/bin/* env_keep+="PATH"
      Defaults!ALL !requiretty
      Defaults!ALL !pam_session
    '';
  };
}
