{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./drivers.nix
    ./power-management.nix
  ];
}
