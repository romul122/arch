#!/bin/bash
read -p "������� ��� ����������: " hostname
read -p "������� ��� ������������: " username

echo '����������� ��� ����������'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime

echo '3.4 ��������� ������� ������ �������'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo '������� ������� ������ �������'
locale-gen

echo '��������� ���� �������'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo '��������� KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo '�������� ����������� RAM ����'
mkinitcpio -p linux

echo '3.5 ������������� ���������'
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

echo '��������� grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo '������ ��������� ��� Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo '��������� ������������'
useradd -m -g users -G wheel -s /bin/bash $username

echo '������� root ������'
passwd

echo '������������� ������ ������������'
passwd $username

echo '������������� SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo '��������������� ����������� multilib ��� ������ 32-������ ���������� � 64-������ �������.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "���� ������������ Arch Linux �� ����������� ������?"
read -p "1 - ��, 0 - ���: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

echo '������ ���� � ��������'
pacman -S $gui_install

echo "������ I3-WM"
pacman -S i3-wm i3-gaps i3status sbxkb dmenu pcmanfm ttf-font-awesome feh lxappearance thunar gvfs udiskie xorg-xbacklight ristretto tumbler picom --noconfirm

echo 'C����� DM'
pacman -S sddm --noconfirm
systemctl enable lxdm

echo '������ ������'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

echo '������ ����'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo '���������� ������������ ��������� ����� � ��������'
systemctl enable NetworkManager

echo '��������� ���������! ������������� �������.'
echo '���� ������ ���������� AUR, ����� ����� ����������� � ����� � �������, ���������� wget (sudo pacman -S wget) � ��������� �������:'
echo 'wget git.io/arch1_3.sh && sh arch1_3.sh'
exit