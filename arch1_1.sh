#!/bin/bash

loadkeys ru
setfont cyr-sun16

echo '2.3 ������������� ��������� �����'
timedatectl set-ntp true

echo '2.4 �������� ��������'
(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo +1000M;

  echo n;
  echo;
  echo;
  echo;
  echo +100G;

  echo n;
  echo;
  echo;
  echo;
  echo +1024M;

  echo n;
  echo p;
  echo;
  echo;
  echo a;
  echo 1;

  echo w;
) | fdisk /dev/sda

echo '���� �������� �����'
fdisk -l

echo '2.4.2 �������������� ������'
mkfs.ext2  /dev/sda1 -L boot
mkfs.ext4  /dev/sda2 -L root
mkswap /dev/sda3 -L swap
mkfs.ext4  /dev/sda4 -L home

echo '2.4.3 ������������ ������'
mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
swapon /dev/sda3
mount /dev/sda4 /mnt/home

echo '3.1 ����� ������ ��� ��������. ������ ������� �� ������'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 ��������� �������� �������'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 ��������� �������'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/arch1_2.sh)"