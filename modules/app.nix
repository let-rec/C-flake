{ lib, pkgs, config, flake, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;

  cfg = config.services.name;

in {
  options = {
    services."C-flake" = {
      enable = mkEnableOption "C-flake";

      user = mkOption {
        type = types.str;
        default = "C-flake";
        description = "User for running system + a C-flake essing keys";
      };

      users.groups = mkIf (cfg.group == "C-flake") {
        "C-flake" = {};
      };

      package = mkOption {
        type = types.package;
        default = flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
        description = ''
          Compiled C-flake actix server package to use with the service.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services."C-flake" = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${lib.getBin cfg.package}/bin/C-flake -g'app, ${lib.escapeShellArg cfg.greeter}!'";
          Restart = "once";
        };
      };
    };
  };
}
