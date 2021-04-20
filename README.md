# aspace-umd-lib-handle-service plugin

UMD Libraries Handle Service Plugin

## Description

This is a plugin for ArchivesSpace that mints UMD handles on creation of new
Resource records in ArchivesSpace. To create the handle, the PUI URL and
information about the resource are sent via a POST request to the
[umd-handle][umd-handle] application, which returns a URI that can be used to
resolve the PUI URL.

This plugin is written to work with ArchivesSpace v2.7.1, and
umd-handle API v1.0.0.

## Configuration

First download this plugin and place it into the ArchivesSpace plugin
directory.

Enable the plugin in the config/config.rb:

```
AppConfig[:plugins] << "aspace-umd-lib-handle-service"
```

It is advised that you add this plugin last, to ensure all other hooks to the
Resource record are also loaded before this plugin's hooks are loaded.

The following settings should also be provided and configured as appropriate:

```
# The full URL to the umd-handle REST API endpoint for minting handles
AppConfig[:umd_handle_server_url] = 'http://handle-test.lib.umd.edu/api/v1/handles'

# The JWT token for authentication to the umd-handle REST API endpoint
# See the README.md in the "umd-handle" application for more information.
AppConfig[:umd_handle_jwt_token] = '<JWT_TOKEN>'

# The Handle.net prefix to use in generating handle URLs (typically "1903.1")
AppConfig[:umd_handle_prefix] = '1903.1'

# Identify the application the handle is being generated for (typically "aspace")
# Note: This must match a known "repo" value in the umd-handles application
AppConfig[:umd_handle_repo] = 'aspace'
```

----
[umd-handle]: https://github.com/umd-lib/umd-handle