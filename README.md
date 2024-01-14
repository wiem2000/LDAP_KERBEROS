
# Projet d'Authentification avec OpenLDAP, SSH, Apache, OpenVPN, DNS et Kerberos

## Objectifs du Projet
Le projet vise à mettre en place une infrastructure d'authentification robuste en utilisant OpenLDAP, SSH, Apache, OpenVPN, DNS et Kerberos. 

## Dossiers du Projet

### 1. `serveur_ldap-openvpn-kerberos`
   - Contient les fichiers de configuration du serveur LDAP.
   - Configuration du serveur OpenVPN pour utiliser l'authentification OpenLDAP.
   - Configuration du serveur Kerberos (KDC) avec ajout de principaux ,récuperation des TGT et son integration avec opneLdap .

### 2. `client_ldap-apache2-openvpn`
   - Configuration du client LDAP pour l'authentification via OpenLDAP.
   - Configuration du serveur Apache2 pour utiliser l'authentification OpenLDAP.
   - Configuration du client OpenVPN pour se connecter au serveur OpenVPN.

### 3. `client_kerberos-ldap`
   - Configuration de la machine cliente pour l'authentification LDAP avec Kerberos via SSSD.

## Utilisation

1. **Serveur LDAP, OpenVPN, Kerberos**

   #### Configuration du serveur LDAP
   - Modifier le fichier `/etc/ldap/ldap.conf` en indiquant la base `dc=ldap, dc=com` et l'URI `ldap://localhost:389` avec le port 389.
   - Ajout d'entités (unités organisationnelles, groupes et utilisateurs) dans l’annuaire LDAP avec le fichier LDIF `add_users_groups.ldif`.

   #### Configuration d’un serveur OpenLDAP sécurisé avec SSL/TLS
   - Copier les fichiers clés nécessaires (clé privée, certificat, fichier de certificats de l'autorité de certification) dans le répertoire `/etc/ldap/sasl2/`.
   - Modifier le fichier `SSL-LDAP.ldif` (indiquer le chemin du certificat CA (`ca-certificates.crt`) à la configuration TLS, remplacer le chemin du fichier de certificat serveur existant par le nouveau chemin, remplacer le chemin du fichier de clé privée existant par le nouveau chemin).
   - Modifier les fichiers `/etc/default/slapd` (spécifier le chemin du fichier CA pour le certificat TLS dans la variable `TLS_CACERT`) et `/etc/ldap/ldap.conf` (ajouter le `ldaps:///`).
   #### configuration du serveur openvpn
   - Modifier le fichier `/etc/openvpn/auth/auth-ldap.conf`.
     - Définir l'adresse IP du serveur Active Directory.
     - Utiliser un compte de service avec le moins de privilèges possible pour le BindDN.
     - Configurer la section Autorisation avec le DN de base pour trouver les utilisateurs et l'attribut SearchFilter avec la valeur « UID ».
   - Ajouter la ligne suivante à la fin du fichier `/etc/openvpn/server.conf` :
     ```
     Plugin /usr/lib/openvpn/openvpn-auth-ldap.so /etc/openvpn/auth/auth-ldap.conf
     ```
   - Utiliser la commande suivante pour créer un tunnel avec OpenVPN :
     ```
     sudo openvpn --config /etc/openvpn/server.conf
     ```
    #### Configuration du Serveur Kerberos

   - Assurez-vous que les horloges sont synchronisées entre les deux machines pour éviter les rejeux de tickets.
   - Modifiez les fichiers `/etc/hosts` sur les machines serveur et client pour configurer la résolution du nom d'hôte.
   - Assurez-vous que `/etc/krb5.conf` contient les informations correctes (kdc, admin-server, default realm).
   - le fichier `/etc/krb5kdc/kdc.conf` contient la base de données des principaux, le keytab, et la durée maximale d'un ticket.
   - Ajoutez le principal de l'utilisateur administrateur au contrôle d'accès dans `/etc/krb5kdc/kadm5.acl`.
   - Créez le principal `host` et le fichier keytab correspondant.
   - Testez l'utilisateur principal `root/admin`.
   - Affichez les informations sur le Ticket Granting Ticket (TGT).
 
   

3. **Client LDAP, Apache2, OpenVPN**
   ####  Configuration du serveur apache avec authentification openLDAP
   - Configuration du serveur Apache2 pour l'authentification OpenLDAP.
   - Modification du fichier `/etc/apache2/apache2.conf` pour autoriser les fichiers `.htaccess`.
   - Création d'une page HTML de test à héberger dans le dossier `/ldap`.
   - Création d'un fichier `.htaccess` pour configurer l'authentification LDAP.
   - Tester en ouvrant le navigateur web avec l’adresse du serveur web et accéder à l'URL http://IP_ADDRESS/ldap.
  
   #### Configuration du client openvpn`
   - Création de la configuration pour les clients OpenVPN.
   - Créer le fichier `/etc/openvpn/client.conf` avec les configurations nécessaires.
     - Ajouter la directive `auth-user-pass` pour permettre aux clients d'entrer leurs identifiants LDAP.
   - Utiliser la commande suivante pour créer un tunnel remote avec OpenVPN :
     ```
     sudo openvpn --config /etc/openvpn/client.conf
     ```

4. **Client Kerberos-LDAP**
   
   #### Configuration du Client Kerberos
   - Connexion en utilisant le principal administrateur que vous avez créé (root/admin).
   - Récupérer les tickets pour le principal administrateur
   - Créer le fichier de configuration `/etc/sssd/sssd.conf` avec les informations nécessaires, notamment le domaine LDAP, l'URI LDAP, la base de recherche LDAP, le serveur KDC, et le realm KDC.
   - Modifier le fichier de configuration `/etc/ldap/ldap.conf` pour configurer le client afin de communiquer avec le serveur LDAP.
   - Redémarrer le service SSSD pour appliquer les modifications.


Assurez-vous d'adapter les fichiers de configuration en fonction de votre environnement spécifique.
