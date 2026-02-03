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

```text
AppConfig[:plugins] << "aspace-umd-lib-handle-service"
```

It is advised that you add this plugin last, to ensure all other hooks to the
Resource record are also loaded before this plugin's hooks are loaded.

The following settings should also be provided and configured as appropriate:

```text
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

## Verification Steps

The following steps are provide basic verification that the
umd_aeon_fulfillment_plugin is working properly.

**These steps are not intended to be an exhaustive test plan.**

The steps assume that:

* ArchivesSpace and the "umd-handle" application are running in Kubernetes.
The steps are specified using URLs for the Kubernetes "test" namespace, as that
seems to be the most useful.

* the user can log in via CAS as a user with "administrator" privileges

As these steps create (and remove) an ArchivesSpace resource and handle, they
should *not* be run in the "production" environment.

1\) In a web browser, go to the ArchivesSpace staff interface home page. Log
in as a user with administration permissions.

2\) In the navigation bar, left-click the "Select Repository" drop-down, select
the "SCUA" repository, and left-click the "Select Repository" button. The
page will refresh and indicate that the "SCUA" repository is now active.

3\) In the application menubar, select "Create | Resource".
The "New Resource" form will be displayed.

4\) On the "New Resource" form, fill out the required fields:

Field | Value
----- | -----
Basic Information - Title | `aspace-umd-lib-handle-service Test Resource`
Basic Information - Identifier | `ABCD` `1234` `9876` `ZYXW`
Basic Information - Level of Description | `Collection`
Basic Information - Publish? | (Left-click to select)
Dates - Type | `Single`
Dates - Begin | `2025-12-16`
Extents - Number | 1

then left-click the "Save Resource" button at the bottom of the form.

5\) After the form refreshes, verify that in the "Finding Aid Data" section, the
"EAD Location" field contains a handle URL. For example, on the test server,
the URL would have the form `https://hdl-test.lib.umd.edu/1903.1/<Integer>`

6\) In a web browser, go to the associated UMD handle server. For example, for
the Kubernetes "test" namespace, go to <https://handle-test.lib.umd.edu/>.

After logging in, the "UMD Handle Service" dashboard will be displayed.

7\) On the "UMD Handle Service" dashboard, left-click the "Handle" link in the
left sidebar. A list of handles will be displayed. Verify that the handle URL
from the previous steps is listed.

8\) Left-click on the handle URL (in the "URL" column), and verify that an
ArchivesSpace public interface page is shown for the
"aspace-umd-lib-handle-service Test Resource" collection.

9\) Left-click the browser "Back" button to return to the UMD Handle page.
Left-click the handle (in the "Handle" column) to display the handle detail
page.

10\) On the handle detail page, left-click the "Delete" button at the bottom of
the page to delete the handle. On the confirmation page, left-click the
"Yes, I'm sure" button. The page will refresh and display a notification that
the handle was deletd.

11\) In the ArchivesSpace staff interface, search for the
``aspace-umd-lib-handle-service Test Resource`` collection. Left-click the "Edit"
button. The "aspace-umd-lib-handle-service Test Resource" detail page will be
displayed.

12\) On the "aspace-umd-lib-handle-service Test Resource" detail page, left-click
the "Delete" button, then left-click the "Delete" button in the confirmation
dialog. The page will refresh with a notification indicating that the resource
was deleted.

----
[umd-handle]: https://github.com/umd-lib/umd-handle
