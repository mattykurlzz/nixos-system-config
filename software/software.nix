{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./rclone.nix
    ./yazi.nix
    ./sound/sound.nix
    ./window-manager/window-manager.nix
  ];
  #
  #   environment.systemPackages = [
  #     pkgs.home-manager
  #   ];
}
