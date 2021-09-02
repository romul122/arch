#!/bin/bash
read -p "Введите имя компьютера: " hostname
read -p "Ââåäèòå èìÿ ïîëüçîâàòåëÿ: " username

echo 'Ïðîïèñûâàåì èìÿ êîìïüþòåðà'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime

echo '3.4 Äîáàâëÿåì ðóññêóþ ëîêàëü ñèñòåìû'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Îáíîâèì òåêóùóþ ëîêàëü ñèñòåìû'
locale-gen

echo 'Óêàçûâàåì ÿçûê ñèñòåìû'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Âïèñûâàåì KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Ñîçäàäèì çàãðóçî÷íûé RAM äèñê'
mkinitcpio -p linux

echo '3.5 Óñòàíàâëèâàåì çàãðóç÷èê'
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

echo 'Îáíîâëÿåì grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ñòàâèì ïðîãðàììó äëÿ Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo 'Äîáàâëÿåì ïîëüçîâàòåëÿ'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Ñîçäàåì root ïàðîëü'
passwd

echo 'Óñòàíàâëèâàåì ïàðîëü ïîëüçîâàòåëÿ'
passwd $username

echo 'Óñòàíàâëèâàåì SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Ðàñêîììåíòèðóåì ðåïîçèòîðèé multilib Äëÿ ðàáîòû 32-áèòíûõ ïðèëîæåíèé â 64-áèòíîé ñèñòåìå.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Êóäà óñòàíàâëèâåì Arch Linux íà âèðòóàëüíóþ ìàøèíó?"
read -p "1 - Äà, 0 - Íåò: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

echo 'Ñòàâèì èêñû è äðàéâåðà'
pacman -S $gui_install

echo "Ñòàâèì I3-WM"
pacman -S i3-wm i3-gaps i3status sbxkb dmenu pcmanfm ttf-font-awesome feh lxappearance thunar gvfs udiskie xorg-xbacklight ristretto tumbler picom --noconfirm

echo 'Còàâèì DM'
pacman -S sddm --noconfirm
systemctl enable lxdm

echo 'Ñòàâèì øðèôòû'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

echo 'Ñòàâèì ñåòü'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Ïîäêëþ÷àåì àâòîçàãðóçêó ìåíåäæåðà âõîäà è èíòåðíåò'
systemctl enable NetworkManager

echo 'Óñòàíîâêà çàâåðøåíà! Ïåðåçàãðóçèòå ñèñòåìó.'
echo 'Åñëè õîòèòå ïîäêëþ÷èòü AUR, òîãäà ïîñëå ïåðåçàãðçêè è âõîäà â ñèñòåìó, óñòàíîâèòå wget (sudo pacman -S wget) è âûïîëíèòå êîìàíäó:'
echo 'wget git.io/arch1_3.sh && sh arch1_3.sh'
exit
