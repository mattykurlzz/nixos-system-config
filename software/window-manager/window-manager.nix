{ pkgs, ... }:

{
  # Polkit enable for niri
  security.polkit.enable = true;

  # Enable services for notifications and sudo pass poll
  systemd.user.services.polkit-kde-agent = {
    description = "KDE Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  systemd.user.services.swaync = {
    description = "SwayNC notification daemon and control center";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
      ExecReload = [
        "${pkgs.swaynotificationcenter}/bin/swaync-client -R"
        "${pkgs.swaynotificationcenter}/bin/swaync-client -rs"
      ];
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  programs.uwsm.enable = true;

  programs.uwsm.waylandCompositors.niri = {
    prettyName = "Niri";
    comment = "Niri compositor";
    binPath = "/run/current-system/sw/bin/niri-session";
  };
}
