#!/bin/bash

# Fonction principale du programme
function main() {
    # Bannière du programme
    banner="
**************************
*  Ansible x Centreon  *
**************************
"

    # Boucle principale du menu
    while true; do
        echo -e "\e[1;34m$banner\e[0m" # Affichage de la bannière
        echo -e "Menu :\n"
        echo "1 | Une fonction à la fois"
        echo "2 | Action multiple"
        echo "3 | Gérer les adresses IP dans l'inventaire"
        echo -e "4 | Quitter\n"
        read -p "Choisissez une option : " option

        case $option in
            1)
                menuUneFonction # Appel de la fonction pour le premier choix
                ;;
            2)
                menuActionMultiple # Appel de la fonction pour le deuxième choix
                ;;
            3)
                gererAdressesIP # Appel de la fonction pour le troisième choix
                ;;
            4)
                echo -e "\e[1;32mProgramme terminé.\e[0m" # Sortie du programme
                exit 0
                ;;
            *)
                echo -e "\e[1;31mOption non valide. Veuillez choisir une option valide.\e[0m"
                sleep 3
                ;;
        esac
    done
}

# Fonction pour le menu "Une fonction à la fois"
function menuUneFonction() {
    while true; do
        echo -e "\nMenu 'Une fonction à la fois' :\n"
        echo "1 | Installer & Configurer le service SNMP"
        echo "2 | Ajouter et configurer l'hôte sur Centreon"
        echo "3 | Changer le mot de passe d'un utilisateur"
        echo "4 | Supprimer un hôte sur Centreon"
        echo -e "5 | Retour au menu principal\n"
        read -p "Choisissez une option : " option

        case $option in
            1)
                configurerSNMP
                ;;
            2)
                ajouterConfigurerCentreon
                ;;
            3)
                changerMotDePasse
                ;;
            4)
                supprimerHoteCentreon
                ;;
            5)
                return
                ;;
            *)
                echo -e "\e[1;31mOption non valide. Veuillez choisir une option valide.\e[0m"
                sleep 3
                ;;
        esac
    done
}

# Fonction pour le menu "Action multiple"
function menuActionMultiple() {
    while true; do
        echo -e "\nMenu 'Action multiple' :\n"
        echo "1 | Installation et configuration SNMP + Ajout hôte Centreon + Modification du mot de passe de la machine"
        echo "2 | Supprimer l'hôte de Centreon et Désinstaller le service SNMP"
        echo -e "3 | Retour au menu principal\n"
        read -p "Choisissez une option : " option

        case $option in
            1)
                configurerSnmpAjouterHoteChangerPsswd
                ;;
            2)
                supprimerEtDesinstaller
                ;;
            3)
                return
                ;;
            *)
                echo -e "\e[1;31mOption non valide. Veuillez choisir une option valide.\e[0m"
                sleep 3
                ;;
        esac
    done
}

# Fonction pour gérer les adresses IP dans l'inventaire
function gererAdressesIP() {
    while true; do
        echo -e "\e[1;34m\nGérer les adresses IP dans l'inventaire\e[0m"
        echo -e "\nMenu :\n"
        echo "1 | Lister les adresses IP dans [windows] et [linux]"
        echo "2 | Ajouter une adresse IP"
        echo "3 | Supprimer une adresse IP"
        echo -e "4 | Retour au menu principal\n"
        read -p "Choisissez une option : " ip_option

        case $ip_option in
            1)
                listerAdressesIP
                ;;
            2)
                ajouterAdresseIP
                ;;
            3)
                supprimerAdresseIP
                ;;
            4)
                return
                ;;
            *)
                echo -e "\e[1;31mOption non valide. Veuillez choisir une option valide.\e[0m"
                sleep 3
                ;;
        esac
    done
}

# Fonction pour lister les adresses IP dans les sections [windows] et [linux]
function listerAdressesIP() {
    while true; do
        echo -e "\e[1;34m\nLister les adresses IP de la section [windows] et [linux]\e[0m"
        echo -e "\e[1;36m\nAdresses IP dans [windows]:\e[0m"
        sed -n '/\[windows\]/,/^\[/p' inventory.ini | grep "ansible_host" | awk '{print $NF}'    

        echo -e "\e[1;36m\nAdresses IP dans [linux]:\e[0m"
        sed -n '/\[linux\]/,/^\[/p' inventory.ini | grep "ansible_host" | awk '{print $NF}'

        sleep 2
        return
    done
}

# Fonction pour ajouter une adresse IP à l'inventaire
function ajouterAdresseIP() {
    echo -e "\e[1;34m\nAjouter une adresse IP\n\e[0m"
    read -p "Veuillez entrer une nouvelle adresse IP : " new_ip
    while true; do
        read -p "Veuillez choisir la section [windows] ou [linux] : " section

        case $section in
            windows*)
                prefix="windows_machine ansible_port=5985 ansible_host="
                ;;
            linux*)
                prefix="linux_machine ansible_host="
                ;;
            *)
                echo -e "\e[1;31m\nSection non valide. Veuillez choisir 'windows' ou 'linux'.\n\e[0m"
                sleep 1
                continue
                ;;
        esac

        sed -i "/\[$section\]/ a $prefix$new_ip" inventory.ini
        echo -e "\e[1;32m\nAdresse IP ajoutée avec succès dans la section [$section].\e[0m"
        sleep 4
        return
    done
}

# Fonction pour supprimer une adresse IP de l'inventaire
function supprimerAdresseIP() {
    echo -e "\e[1;34m\nSupprimer une adresse IP\n\e[0m"
    read -p "Veuillez entrer l'adresse IP à supprimer :" ip_to_remove
    sed -i "/$ip_to_remove/d" inventory.ini
    echo -e "\e[1;32m\nAdresse IP supprimée avec succès.\e[0m"
    sleep 4
}

# Fonction pour installer et configurer le service SNMP
function configurerSNMP() {
    echo -e "\e[1;34m\nInstaller & Configurer le service SNMP\e[0m"
    echo -e "Veuillez choisir le type de machine à configurer (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*)
                ansible-playbook -i inventory.ini playbook/linux_install_configure_snmp.yml -e target=$machine_type
                echo -e "\e[1;32mInstallation et configuration SNMP terminée avec succès.\e[0m"
                sleep 4
                return
                ;;
            windows*)
                ansible-playbook -i inventory.ini playbook/windows_install_configure_snmp.yml -e target=$machine_type
                echo -e "\e[1;32mInstallation et configuration SNMP terminée avec succès.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fonction pour ajouter et configurer un hôte sur Centreon
function ajouterConfigurerCentreon() {
    echo -e "\e[1;34m\nAjouter et configurer l'hôte sur Centreon\e[0m"
    echo -e "Veuillez choisir le type de machine à ajouter sur Centreon (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*)
                ansible-playbook -i inventory.ini playbook/add_linux_snmp_centreon.yml -e target=$machine_type
                echo -e "\e[1;32mHôte ajouté et configuré sur Centreon avec succès.\e[0m"
                sleep 4
                return
                ;;
            windows*)
                ansible-playbook -i inventory.ini playbook/add_windows_snmp_centreon.yml -e target=$machine_type
                echo -e "\e[1;32mHôte ajouté et configuré sur Centreon avec succès.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fonction pour changer le mot de passe d'un utilisateur sur les machines
function changerMotDePasse() {
    echo -e "\e[1;34m\nChanger le mot de passe d'un utilisateur\e[0m"
    echo -e "Veuillez choisir le type de machine pour changer le mot de passe (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*)
                ansible-playbook -i inventory.ini playbook/linux_change_psswd.yml -e target=$machine_type
                echo -e "\e[1;32mLe mot de passe de l'utilisateur a été changé avec succès sur les machines Linux.\e[0m"
                sleep 4
                return
                ;;
            windows*)
                ansible-playbook -i inventory.ini playbook/windows_change_psswd.yml -e target=$machine_type
                echo -e "\e[1;32mLe mot de passe de l'utilisateur a été changé avec succès sur les machines Windows.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fonction pour supprimer un hôte sur Centreon
function supprimerHoteCentreon() {
    echo -e "\e[1;34m\nSupprimer un hôte sur Centreon\e[0m"
    echo -e "Veuillez choisir le type de machine à supprimer sur Centreon (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*|windows*)
                ansible-playbook -i inventory.ini playbook/delete_host_centreon.yml -e target=$machine_type
                echo -e "\e[1;32mHôte supprimé avec succès sur Centreon.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fonction pour exécuter plusieurs actions : installer SNMP, ajouter hôte sur Centreon, changer mot de passe
function configurerSnmpAjouterHoteChangerPsswd() {
    echo -e "\e[1;34m\nInstallation et configuration SNMP + Ajout hôte Centreon + Modification du mot de passe de la machine\e[0m"
    echo -e "Veuillez choisir le type de machine pour l'opération (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*)
                ansible-playbook -i inventory.ini playbook/linux_install_configure_snmp.yml -e target=$machine_type
                ansible-playbook -i inventory.ini playbook/add_linux_snmp_centreon.yml -e target=$machine_type
                ansible-playbook -i inventory.ini playbook/linux_change_psswd.yml -e target=$machine_type
                echo -e "\e[1;32mOpération terminée avec succès sur les machines Linux.\e[0m"
                sleep 4
                return
                ;;
            windows*)
                ansible-playbook -i inventory.ini playbook/windows_install_configure_snmp.yml -e target=$machine_type
                ansible-playbook -i inventory.ini playbook/add_windows_snmp_centreon.yml -e target=$machine_type
                ansible-playbook -i inventory.ini playbook/windows_change_psswd.yml -e target=$machine_type
                echo -e "\e[1;32mOpération terminée avec succès sur les machines Windows.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fonction pour désinstaller le service SNMP
function desinstallerSNMP() {
    echo -e "\e[1;34m\nDésinstaller le service SNMP\e[0m"
    echo -e "Veuillez choisir le type de machine à désinstaller (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*)
                ansible-playbook -i inventory.ini playbook/linux_uninstall_snmp.yml -e target=$machine_type
                echo -e "\e[1;32mService SNMP désinstallé avec succès sur les machines Linux.\e[0m"
                sleep 4
                return
                ;;
            windows*)
                ansible-playbook -i inventory.ini playbook/windows_uninstall_snmp.yml -e target=$machine_type
                echo -e "\e[1;32mService SNMP désinstallé avec succès sur les machines Windows.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Fonction pour supprimer l'hôte de Centreon et désinstaller le service SNMP
function supprimerEtDesinstaller() {
    echo -e "\e[1;34m\nSupprimer l'hôte de Centreon et Désinstaller le service SNMP\e[0m"
    echo -e "Veuillez choisir le type de machine à désinstaller (linux/windows):\n"
    while true; do
        read -p "Choisissez une option : " machine_type

        case $machine_type in
            linux*)
                ansible-playbook -i inventory.ini playbook/delete_host_centreon.yml -e target=$machine_type
                ansible-playbook -i inventory.ini playbook/linux_uninstall_snmp.yml -e target=$machine_type
                echo -e "\e[1;32mHôte supprimé de Centreon et service SNMP désinstallé avec succès sur les machines Linux.\e[0m"
                sleep 4
                return
                ;;
            windows*)
                ansible-playbook -i inventory.ini playbook/delete_host_centreon.yml -e target=$machine_type
                ansible-playbook -i inventory.ini playbook/windows_uninstall_snmp.yml -e target=$machine_type
                echo -e "\e[1;32mHôte supprimé de Centreon et service SNMP désinstallé avec succès sur les machines Windows.\e[0m"
                sleep 4
                return
                ;;
            *)
                echo -e "\e[1;31m\nType de machine non reconnu. Veuillez choisir 'linux' ou 'windows'.\n\e[0m"
                sleep 1
                ;;
        esac
    done
}

# Lancement de la fonction principale
main
