#!/bin/bash
mkdir ~/downloads
cd ~/downloads

echo '��������� AUR (yay)'
sudo pacman -Syu
sudo pacman -S wget --noconfirm
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm

echo '������� ������ ����������'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo '��������� ������� �������� � �������'
sudo pacman -S reflector f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol --noconfirm

echo '���������� ������������ ���������?'
read -p "1 - ��, 0 - ���: " prog_set
if [[ $prog_set == 1 ]]; then
  #����� �������� �� pacman -Qqm > ~/.pacmanlist.txt
  sudo pacman -S recoll chromium flameshot veracrypt vlc freemind filezilla neofetch screenfetch qbittorrent galculator telegram-desktop atom htop shotwell ristretto--noconfirm
  yay -Syy
  yay -S xflux sublime-text-dev hunspell-ru pamac-aur-git megasync-nopdfium trello xorg-xkill ttf-symbola ttf-clear-sans --noconfirm
elif [[ $prog_set == 0 ]]; then
  echo '��������� �������� ���������.'
fi
 
  echo '������ ���� ArchLinux � ����'
  wget git.io/arch_logo.png
  sudo mv -f ~/downloads/arch_logo.png /usr/share/pixmaps/arch_logo.png
  
echo '���������� conky?'
read -p "1 - ��, 0 - ���: " conky_set
if [[ $conky_set == 1 ]]; then
  sudo pacman -S conky conky-manager --noconfirm
  wget git.io/conky.tar.gz
  tar -xzf conky.tar.gz -C ~/
elif [[ $conky_set == 0 ]]; then
  echo '��������� conky ���������.'
fi

echo '������ ���� ���� ��� DE?'
read -p "1 - ��, 0 - ���: " node_set
if [[ $node_set == 1 ]]; then
sudo systemctl disable sddm
sudo pacman -R sddm
sudo pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xserverrc ~/.xserverrc
wget https://raw.githubusercontent.com/ordanax/arch/master/attach/.xinitrc
sudo mv -f .xinitrc ~/.xinitrc
wget https://raw.githubusercontent.com/ordanax/arch/master/attach/.bashrc
rm ~/.bashrc
sudo mv -f .bashrc ~/.bashrc
wget https://raw.githubusercontent.com/ordanax/arch/master/attach/grub
sudo mv -f grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
read -p "������� ��� ������������: " username
sudo echo -e '[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin' "$username" '--noclear %I $TERM' > ~/downloads/override.conf
sudo mkdir /etc/systemd/system/getty@tty1.service.d/
sudo mv -f ~/downloads/override.conf /etc/systemd/system/getty@tty1.service.d/override.conf
elif [[ $node_set == 0 ]]; then
  echo '����������.'
fi

# ���������� zRam
yay -S zramswap --noconfirm
sudo systemctl enable zramswap.service

# �������
rm -rf ~/downloads/

echo '��������� ���������!'