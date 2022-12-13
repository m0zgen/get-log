# Get-Log.sh Script

Get remote file from server and copy file to local `collection` folder.

Example:
```
./get-log.sh -l my-servers.txt -f /var/log/server.log -s
```

# Features

* Works with server list file
* Checking (or skip) remote server is on-line (with `ping`)
* Automatically create `collection` catalog
* Automatically create `<server_name>` catalog in `collection`

## Params

* `-s` - Skip server online checking 
* `-f` - Path to remote file
* `-l` - Server list