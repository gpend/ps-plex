# PowerShell scripts to manage TV seasons in Plex

These scripts can be used to organize video files from discs. The result will be a show folder with folders inside containing a seasons files.

Requirements: powershell, and files in mkv format.  
&ensp;The scrips can be edited for other video file formats.

use "seasonRename discs to season folder.ps1" to reorganize files when they are in individual disc folders.
```
\show name\disc 1\{ files }
\show name\disc 2\{ files }
...
```
use "seasonRename singe folder to season.ps1" to reorganize files when they are all in a single folder.
```
\show name\{ files }
...
```
