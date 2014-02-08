d7-generic-vagrant
==================

Vagrant companion to the d7-generic repository

1. Download and Install Virtualbox (https://www.virtualbox.org/wiki/Downloads)
2. Download and Install Vagrant (http://downloads.vagrantup.com/tags/v1.2.2)
3. Create/download/clone a Drupal site of your choice in a repository named d7-generic
4. d7-generic and d7-generic-vagrant should be at the same directory level.
5. Create an empty directory named "vagrant_xfer" at that same directory level
6. Create Virtual Machine.  From within the d7-generic-vagrant repo:
7. Profit

```Shell
$ vagrant up
$ vagrant ssh # To access your vagrant box.
```

**First Provision**

The first time you provision your vagrant box (vagrant up) you will need to populate your
/var/www/html/d7-generic directory and the drupal database.

After you "vagrant ssh" run the following command:

```Shell
$ publish -fp # which will rsync the files from your d7-generic to your /var/www/html/d7-generic
```

##File transfers
The "vagrant_xfer" directory that you created simply serves as a convenient way to
get files into and out of the vagrant box.  There are umpteen other ways to do this,
so feel free to use a different method if you prefer.

##To View and Change MySQL

* MySQL Server
* Server: 127.0.0.1
* Port: 8889 (or whatever you have configured in the Vagrantfile)
* User Name: d7_user
* Password:  d7_pass
* Database: d7_db

##User 1 login (best practice is to not use this unless absolutely necessary)
Super Admin / password

##Admin password (gets all permissions via the adminrole module, use this instead of user 1)
Admin / password

Only a minimal number of modules are enabled.  But for convenience, some 
additional common ones are included (Views, Rules, etc.) and ready to enable.

As configured, only administrators can create accounts.  Change that
under Configuration => People => Account Settings if you like.

The server-side configuration includes goodies like Solr, Memcache, Varnish, XDebug, and CAS.
Most "just to play with a new module" sites won't need these.  Feel free to comment them
out in setup.sh, as they make the vagrant box slower to set up and heavier to run.  They 
are present simply because it is much quicker to comment them out than to add them if they
were not included in the first place.

XDebug and CAS are not configured by default, but the configuration scripts are copied.
So just run either "xdebugsetup" or "cassetup" within the Vagrant box to install them.