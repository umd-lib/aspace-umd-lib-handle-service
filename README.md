# aspace-umd-lib-handle-service plugin

UMD Libraries Handle Service Plugin

## Description

This is a plugin for ArchivesSpace that mints UMD handles on creation of new
Resource records in ArchivesSpace. To create the handle, the PUI URL and the
Resource identifier are passed to the UMD handle service, which returns a URI
that can be used to resolve the PUI URL.

This plugin is written to work with ArchivesSpace v2.2.2.

## Configuration

First download this plugin and place it into the ArchivesSpace plugin
directory.

Enable the plugin to the config/config.rb:

```
AppConfig[:plugins] << "aspace-umd-lib-handle-service"
```

It is advised that you add this plugin last, to ensure all other hooks to the
Resource record are also loaded before this plugin's hooks are loaded.

There are two configuration settings to be aware of:

```
AppConfig[:umd_handle_server_url] = "http://fedoradev.lib.umd.edu/handle/"
AppConfig[:umd_handle_namespace] = "archives"
```

AppConfig[:umd_handle_server_url] points to the service being used by the
application to mint handles. This is required.

AppConfig[:umd_handle_namespace] is the namespace used in the minting process
for the record's PID. For example, a record with an identifier of 123-AAA-456
will have a PID of "yournamespace:123-AAA-456". This is optional, as the
default is set to 'archives:'.
