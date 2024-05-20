{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 30;

    memtest86.enable = true;
    default = "saved";
    useOSProber = true;
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # make conventional shebangs work
  # system.activationScripts.binbash = {
  #   deps = ["binsh"];
  #   text = ''
  #     ln -s /bin/sh /bin/bash 2>/dev/null
  #   '';
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alexl = {
    isNormalUser = true;
    description = "Alex";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      kate
      #  thunderbird
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "alexl" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    cmake
    gnumake
    gcc
    gdb
    alejandra
    neofetch
    libnotify
    usbutils
    pciutils
    lshw
    tmux
    tree
    opentabletdriver
    chromium
    vlc
    python3
    python311Packages.pip
    solaar # logitech unifying reciever
    remmina # ecs.gg/gpu
    iperf
    kdePackages.plasma-firewall
    teamviewer
    baobab
    zulu8
    teams-for-linux
    libreoffice-qt
    hunspell
    hunspellDicts.en_GB-large
    unrar
    kicad
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    vscode
  ];
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.teamviewer.enable = true;

  # uinfying reciever udev rules:
  hardware.logitech.wireless.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [5201 24800];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
