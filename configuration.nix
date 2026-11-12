# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware/hardware.nix
    ./software/software.nix
  ];

  networking.hostName = "avnek"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver.enable = true;
    displayManager = {
      gdm.enable = true;
      #         gnome.enable = true;
    };
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    # Enable CUPS to print documents.
    # printing.enable = true;
  };

  programs.niri.enable = true;

  # Enable passwordless sudo
  security.sudo.extraRules = [
    {
      users = [ "avnek" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."avnek" = {
    isNormalUser = true;
    description = "avnek";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    linger = true;
  };

  #   home-manager.users.avnek = {
  #     home.username = "avnek";
  #     home.homeDirectory = "/home/avnek";
  #     home.stateVersion = "26.05"; # do not change
  #
  # Expose blesh at the path your script already uses
  #     home.file.".local/share/blesh".source = "${pkgs.blesh}/share/blesh";
  #
  #     programs.bash = {
  #       enable = true;
  #       historyControl = [ "ignoreboth" ];
  #       historySize = 1000;
  #       historyFileSize = 2000;
  #       shellOptions = [
  #         "histappend"
  #         "checkwinsize"
  #       ];
  #       enableCompletion = true;
  #     };
  #   };

  #   home-manager.backupFileExtension = "hm-bak";

  # Clean older versions of nixos periodically
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  boot = {
    kernelParams = [ "i915.enable_guc=3" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [
      "ntfs"
      "exfat"
    ];
  };

  # Docker virtualization
  virtualisation.docker = {
    # Consider disabling the system wide Docker daemon
    enable = false;

    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      #       daemon.settings = {
      #         data-root = "~/.local/docker";
      #         dns = [ "1.1.1.1" "8.8.8.8" ];
      #         registry-mirrors = [ "https://mirror.gcr.io" ];
      #       };
    };
  };

  systemd.user.services.docker = {
    enable = true;
    # This makes the service start automatically with the user's default target
    wantedBy = [ "default.target" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Gnome Keyring daemon
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
