# plex-trakt-sync
A simple Rails application to fetch [Plex](https://www.plex.tv) watched status and push to [Trakt](https://www.trakt.tv)


## Requirements
To use plex-trakt-sync you will need:
### Plex
* A Plex [authentication token](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/).
* Server External IP and port.
  * Can be found under **Settings > Remote Access**, next to Public.
### Trakt

* A new (or existing) Trakt [API app](https://trakt.tv/oauth/applications/new).
  * Give your app a name, and check both the `/check-in` and `/scrobble` permissions. 
  * For redirect url enter `urn:ietf:wg:oauth:2.0:oob`.
  * Save your app and make note of the `Client ID` and `Client Secret`.

## Usage
### Setup
Once you have all your credentials, add them to your Rail credentials in this format:
```yaml
PLEX_AUTH_TOKEN: auth-token-here
PLEX_SERVER: server-ip-here
PLEX_PORT: server-port-here - default is 32400
TRAKT_CLIENT_ID: client-id-here
TRAKT_CLIENT_SECRET: client-secret-here
TRAKT_USERNAME: username-here
TRAKT_ACCESS_TOKEN: # leave this blank for now
TRAKT_REFRESH_TOKEN: # leave this blank for now
TRAKT_ACCESS_TOKEN_EXPIRES_AT: # leave this blank for now
```
### Authorization
Complete the Trakt device authorization from within a rails console.
```ruby
Trakt::Authenticate::Access.call
# Please go to https://trakt.tv/activate and enter the code: YOUR_CODE
# Waiting for user authorization...
```
With the console response from the Trakt Device Authorization, update the remaining `TRAKT_ACCESS_TOKEN`, `TRAKT_REFRESH_TOKEN` and `TRAKT_ACCESS_TOKEN_EXPIRES_AT` values in your rails credentials. 
### Scrobble
Still within the rails console, start the syncing for either Movies or TV series.
```ruby
Plex::Sync::Movie.call
Plex::Sync::Show.call
```
### Ignore List
An optional ignore list lives at `config/ignore_list.yml`

This can be used to prevent specific pieces of media from being synced to Trakt.
```yaml
movies:
tv_shows:
  - The Handmaid's Tale
  - Top Chef
```
## TODO:
1. Add automated UI component for Trakt device authorization and refresh workflows.
2. Better Trakt media matching.
3. Run scrobbling at set intervals.
4. Enqueue future job to continue scrobbling after hitting Trakt API Rate Limit.
