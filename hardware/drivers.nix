{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # VA-API (iHD) userspace
        vpl-gpu-rt # oneVPL (QSV) runtime
        intel-compute-runtime # Optional: OpenCL (NEO) for compute tasks
      ];
    };
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Kernel tweaks
  boot = {
    kernelParams = [ "i915.enable_guc=3" ];
    kernelModules = [
      "ideapad_laptop"
      "kvm-intel"
    ]; # kvm-intel optional
  };

  # support for ntfs drives
  environment.systemPackages = [
    pkgs.ntfs3g
    pkgs.jmtpfs
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };
}
