{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rclone
    pass
    gnupg
    pinentry-all
    fuse3
  ];

  systemd.user.services.rclone-gdrive = {
    description = "On-demand Rclone Mount for Google Drive (Obsidian)";

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt/gdrive";

      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive: %h/mnt/gdrive \
          --vfs-cache-mode full \
          --vfs-cache-max-size 10G
      '';

      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/mnt/gdrive";
      Restart = "on-failure";
      RestartSec = "2s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };
  };
}
