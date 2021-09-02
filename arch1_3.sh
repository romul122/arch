#!/bin/bash
mkdir ~/downloads
cd ~/downloads

echo ''Установка AUR (yay)'
sudo pacman -Syu
sudo pacman -S wget --noconfirm
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm

echo 'Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo 'Установка базовых программ и пакетов'
sudo pacman -S reflector f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol --noconfirm

echo 'Óñòàíîâèòü ðåêîìåíäóìûå ïðîãðàììû?'
read -p "1 - Äà, 0 - Íåò: " prog_set
if [[ $prog_set == 1 ]]; then
  #Ìîæíî çàìåíèòü íà pacman -Qqm > ~/.pacmanlist.txt
  sudo pacman -S recoll chromium flameshot veracrypt vlc freemind filezilla neofetch screenfetch qbittorrent galculator telegram-desktop atom htop shotwell ristretto--noconfirm
  yay -Syy
  yay -S xflux sublime-text-dev hunspell-ru pamac-aur-git megasync-nopdfium trello xorg-xkill ttf-symbola ttf-clear-sans --noconfirm
elif [[ $prog_set == 0 ]]; then
  echo 'Óñòàíîâêà ïðîãðàìì ïðîïóùåíà.'
fi
 
  echo 'Ñòàâèì ëîãî ArchLinux â ìåíþ'
  wget git.io/arch_logo.png
  sudo mv -f ~/downloads/arch_logo.png /usr/share/pixmaps/arch_logo.png
  
echo 'Óñòàíîâèòü conky?'
read -p "1 - Äà, 0 - Íåò: " conky_set
if [[ $conky_set == 1 ]]; then
  sudo pacman -S conky conky-manager --noconfirm
  wget git.io/conky.tar.gz
  tar -xzf conky.tar.gz -C ~/
elif [[ $conky_set == 0 ]]; then
  echo 'Óñòàíîâêà conky ïðîïóùåíà.'
fi

echo 'Äåëàåì àâòî âõîä áåç DE?'
read -p "1 - Äà, 0 - Íåò: " node_set
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
read -p "Ââåäèòå èìÿ ïîëüçîâàòåëÿ: " username
sudo echo -e '[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin' "$username" '--noclear %I $TERM' > ~/downloads/override.conf
sudo mkdir /etc/systemd/system/getty@tty1.service.d/
sudo mv -f ~/downloads/override.conf /etc/systemd/system/getty@tty1.service.d/override.conf
elif [[ $node_set == 0 ]]; then
  echo 'Ïðîïóñêàåì.'
fi

# Ïîäêëþ÷àåì zRam
yay -S zramswap --noconfirm
sudo systemctl enable zramswap.service

# Î÷èñòêà
rm -rf ~/downloads/

echo 'Óñòàíîâêà çàâåðøåíà!'
