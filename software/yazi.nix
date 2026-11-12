{ config, pkgs, ... }:

{
  programs.fuse.userAllowOther = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
