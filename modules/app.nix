{ lib, pkgs, config, flake, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  manifest = {name = "CCrash"; };
  cfg = config.services.name;
  fpkg = flake.packages.${pkgs.stdenv.hostPlatform.system}.default;

  service = mkIf cfg.enable {
    systemd.services."${manifest.name}" = {
      description = "${manifest.name} daemon";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${lib.getBin fpkg}/bin/${manifest.name}";
        Restart = "no";
        DevicePolicy="closed";
        KeyringMode="private";
        LockPersonality="yes";
        MemoryDenyWriteExecute="yes";
        NoNewPrivileges="yes";
        PrivateDevices="yes";
        PrivateTmp="true";
        ProtectClock="yes";
        ProtectControlGroups="yes";
        ProtectHome="read-only";
        ProtectHostname="yes";
        ProtectKernelLogs="yes";
        ProtectKernelModules="yes";
        ProtectKernelTunables="yes";
        ProtectProc="invisible";
        ProtectSystem="full";
        RestrictNamespaces="yes";
        RestrictRealtime="yes";
        RestrictSUIDSGID="yes";
        SystemCallArchitectures="native";
      };
    };
  };

in {
  options = {
    services.${manifest.name} = {
      enable = mkEnableOption "${manifest.name}";

      user = mkOption {
        type = types.str;
        default = "${manifest.name}";
        description = "User for running system + a ${manifest.name} essing keys";
      };

      users.groups = mkIf (cfg.group == "${manifest.name}") {
        ${manifest.name} = {};
      };

      package = mkOption {
        type = types.package;
        default = flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
        description = ''
          Compiled ${manifest.name} actix server package to use with the service.
        '';
      };

    };
  };

  config = mkMerge [service];
}
