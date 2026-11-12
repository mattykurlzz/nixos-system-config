{ pkgs, ... }:

{
  # Provide standard ld interface layer for incompatible bins
  programs.nix-ld.enable = true;
}
