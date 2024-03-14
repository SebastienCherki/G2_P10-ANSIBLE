#!/bin/bash

# Ce script gère les opérations de chiffrement et de déchiffrement des secrets avec Ansible Vault.

# Chemin du fichier contenant les secrets
SECRETS="/root/project-ansible/playbook/secret/windows_credentials/credentials"
# Chemin du fichier contenant le mot de passe pour Ansible Vault
PASSWORD="/root/vault/password.txt"

# Vérifie les arguments passés au script
if [[ "$1" == "-c" ]]; then
    # Crée un coffre-fort Ansible Vault avec le fichier de secrets spécifié
    echo "Création du coffre-fort : $SECRETS\n"
    ansible-vault create $SECRETS --vault-password-file=$PASSWORD
elif [[ "$1" == "-e" ]]; then
    # Chiffre le coffre-fort Ansible Vault avec le mot de passe spécifié
    echo "Chiffrement du coffre-fort : $SECRETS avec $PASSWORD\n"
    ansible-vault encrypt $SECRETS --vault-password-file=$PASSWORD
elif [[ "$1" == "-d" ]]; then
    # Déchiffre le coffre-fort Ansible Vault avec le mot de passe spécifié
    echo "Déchiffrement du coffre-fort : $SECRETS avec $PASSWORD\n"
    ansible-vault decrypt $SECRETS --vault-password-file=$PASSWORD
fi
