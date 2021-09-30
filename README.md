# deb release notifier

Send an email when a new version of a package is released

# Setup/usage

```
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
PACKAGE=cloud-init EMAIL=myemail@example.com ./notifier.sh # you have to setup google creds correctly
```
