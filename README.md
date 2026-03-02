# Nom:Boualem CHEURFA
# Date: 2026-02-28
# Evaluation numéro 2

---

# Déploiement rsyslog, Docker Compose et stack Nginx/PHP/MySQL avec Ansible
Ce dépôt décrit le déploiement automatisé d’une infrastructure basée sur **rsyslog**,**journalisation**, **Docker Compose** et service **Nginx/PHP/MySQL**, orchestrée depuis une **machine de gestion Ansible** vers une **machine distante**.
 
---

## Déploiement Nginx, PHP, MySQL, Docker Compose et création des fichiers/répertoires, installation rsyslog et journalisation via Ansible
## DEPLOYEMENT GLOBAL 
- Installation de Docker et Docker Compose.
- Déploiement de la stack :
  - **Nginx** (reverse proxy / serveur web),
  - **PHP** (backend),
  - **MySQL** (base de données).
- Création automatique :
  - des répertoires applicatifs,
  - des fichiers de configuration,
  - des volumes et réseaux Docker nécessaires.
- Installation rsyslog.
- Journalisation

```bash
      ansible-playbook -i hosts.yaml deploy.yaml --ask-vault-pass --ask-become-pass
```
### Capture 1       
 <img width="905" height="457" alt="image" src="https://github.com/user-attachments/assets/8e2e504d-e56b-4e29-a76a-659eacb78564" />

---

## Fichiers et répertoires de la machine de gestion Ansible (machine de contrôle)
### Capture 2
<img width="257" height="160" alt="image" src="https://github.com/user-attachments/assets/9105751e-34b8-4ab9-9e1b-13f06fb72ed2" />

---


### Fichiers et répertoires générés par le déploiement Ansible à partir de la machine de contrôle (machine distante:srv-web-01)
### Capture 3
<img width="550" height="297" alt="image" src="https://github.com/user-attachments/assets/11abc1a3-1a17-450e-83b4-0011f075fb64" />

Cette machine distante héberge :
- rsyslog configuré.
- Docker + Docker Compose.
- Les conteneurs Nginx, PHP, MySQL.
- Les services exposés (ex. HTTP/HTTPS).

---

## Installation de Docker via le déploiement Ansible (sur le serveur web : srv‑web‑01)

```bash
ansible-playbook -i hosts.yaml deploy.yaml --ask-vault-pass --ask-become-pass --tags "docker"
```
###  Capture 4
<img width="611" height="272" alt="image" src="https://github.com/user-attachments/assets/8d4ef26e-10e9-477a-8e71-9a3b2c1600d8" />

---

## Création des répertoires et des fichiers via le déploiement Ansible (sur le serveur web : srv‑web‑01)

```bash
ansible-playbook -i hosts.yaml deploy.yaml --ask-vault-pass --ask-become-pass --tags "REP_FILES"
```
###  Capture 5
<img width="541" height="268" alt="image" src="https://github.com/user-attachments/assets/b6999284-286f-45e5-ae06-3a76ee450a11" />

---

## Lancer docker compose up via le déploiement Ansible (sur le serveur web : srv‑web‑01)

```bash
ansible-playbook -i hosts.yaml deploy.yaml --ask-vault-pass --ask-become-pass --tags "Lancer docker compose"
```
###  Capture 6
<img width="539" height="107" alt="image" src="https://github.com/user-attachments/assets/524db4fb-e35a-478c-944c-674d0ce498c1" />

---

## Vérification de l’accès SSH

- Accès SSH fonctionnel entre la machine de gestion et la machine distante.
- Utilisé par Ansible pour :
  - exécuter les playbooks,
  - déployer les configurations,
  - récupérer les logs.
    
```bash
ansible -i hosts.yaml -m ping prod
```

### Capture 7
<img width="975" height="260" alt="image" src="https://github.com/user-attachments/assets/9c12f323-8ae0-4782-96ab-6905c77e285b" />

---

## Déploiement rsyslog sur la machine distante

- Installation et configuration de `rsyslog` via Ansible.
- Surveillance des événements système (authentification, SSH, services critiques).
- Possibilité de centraliser les logs vers la machine de gestion ou un serveur dédié.
  
```bash
  ansible-playbook -i hosts.yaml deploy.yaml --ask-vault-pass --ask-become-pass --tags "rsyslog"
```

 ### Capture 8
<img width="607" height="152" alt="image" src="https://github.com/user-attachments/assets/b46b3e67-c2b2-4a01-93a6-055288ee2161" />

---

## La journalisation des logs

- Collecte des logs système (ex. `/var/log/syslog`).
- Utilisation d’Ansible pour :
  - lire les dernières lignes de logs,
  - rapatrier les fichiers de logs sur la machine de gestion,
  - faciliter l’analyse et l’audit.
   
```bash
   ansible-playbook -i hosts.yaml deploy.yaml --ask-vault-pass --ask-become-pass --tags "logs"
```

### Capture 9
<img width="911" height="332" alt="image" src="https://github.com/user-attachments/assets/2c8ea41d-81ee-4030-8940-cd3db22c36f4" />

      
---

## Extrait de journal logs enregistré sur la machine de gestion Ansible

- Les journaux récupérés sont stockés dans un répertoire dédié (par hôte).
- Ils servent de base à :
  - la vérification des déploiements,
  - la détection d’erreurs,
  - la traçabilité des opérations.
    
### Capture 10
<img width="975" height="112" alt="image" src="https://github.com/user-attachments/assets/14d5b8e2-f8b4-4bb0-aa2e-1d178f2fed03" />

---

# Gestion du fichier docker compose

## Arrêter Docker Compose depuis la machine de gestion Ansible

- Playbook Ansible permettant d’exécuter `docker compose down` sur la machine distante.
- Utilisé pour :
  - arrêter proprement les services,
  - préparer une mise à jour ou une maintenance.
          
```bash
    ansible-playbook-i hosts.yaml gestion_docker.yaml --ask-vault-pass --ask-become_pass --tags "stop"
```
### Capture 11
<img width="975" height="368" alt="image" src="https://github.com/user-attachments/assets/cf371738-4eeb-4f5e-93bc-f39accd5874b" />

## Redémarrer Docker Compose depuis la machine de gestion Ansible

- Playbook Ansible exécutant `docker compose up -d`.
- Permet :
  - de redémarrer la stack applicative,
  - de valider la bonne prise en compte des modifications.
    
```bash
    ansible-playbook-i hosts.yaml gestion_docker.yaml --ask-vault-pass --ask-become_pass --tags "restart"
```

### Capture 12
<img width="905" height="134" alt="image" src="https://github.com/user-attachments/assets/c1d91c78-e944-4e4e-9b22-348ce44789e5" />

---

## Page web Nginx

- Déploiement d’un site web servi par Nginx.
- Vérification de l’accessibilité via navigateur ou `curl`.
- Permet de valider :
  - le bon fonctionnement de Nginx,
  - la communication avec PHP et éventuellement MySQL.

### Capture 13
<img width="975" height="601" alt="image" src="https://github.com/user-attachments/assets/f3f3a9ab-40d1-4fc5-bf54-5f2308b5b27c" />


Ce projet illustre une chaîne complète : **journalisation**, **gestion des services Docker**, et **déploiement applicatif** entièrement automatisés avec Ansible.
