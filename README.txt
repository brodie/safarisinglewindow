SafariSingleWindow
==================

SafariSingleWindow is a [SIMBL][1]/[PlugSuit][2] plugin for [Safari][3] that
forces all links that would open in new windows to open in new tabs instead.

No configuration is necessary, just open the `.dmg` file, run `Install`, and
restart Safari. To uninstall, simply run `Uninstall` from the `.dmg`.

If you experience any problems, check Console for lines starting with
`[SafariSingleWindow]`. If you see any, copy them and email them to me,
and I'll see what I can do to fix it.

[1]: http://www.culater.net/software/SIMBL/SIMBL.php
[2]: http://infinite-labs.net/PlugSuit/
[3]: http://www.apple.com/safari/


Download
--------

[SafariSingleWindow.dmg][4] (67 KB)

[4]: http://bitheap.org/singlewindow/SafariSingleWindow.dmg


Frequently Asked Questions
--------------------------

> How is this any better than running `defaults write com.apple.Safari
> TargetedClicksCreateTabs -bool true` with Safari 3.1?

That setting is experimental, and only applies to anchor tags that have
a `target` attribute. It won't work for new windows made via JavaScript
and it may actually cause issues with certain sites. SafariSingleWindow
intercepts *all* requests to create new windows - even ones from JavaScript.

> Won't this plugin break when Apple finishes fleshing out that above
> setting?

No. SafariSingleWindow works on a different level than Safari's setting.
If Apple ever chooses to make it configurable through a dialog, the setting
would simply have no effect if you have SafariSingleWindow installed.

The plugin also uses very little of Safari's API, and it checks for the
presence of those APIs before loading. The majority of the plugin uses
public [WebKit][5] APIs (the open source browser engine that Safari uses).

> Why have my window resizing bookmarklets stopped working?

SafariSingleWindow disables windows resizing from scripts to prevent pop-ups
from clobbering your current window's dimensions. This is intentional, and if
you want to bypass the plugin temporarily to run your bookmarklets, use the
newly added "Single Window Mode" menu item in the "Safari" menu.

[5]: http://webkit.org/


Development
-----------

Download the official development repository using [Mercurial][6]:

    hg clone http://bitheap.org/hg/safarisinglewindow/

Run `make` to compile the plugin, and `make install` to install it into
your home directory's SIMBL plugins folder. Run `make` and `make builddmg`
to create a disk image of the application.

[6]: http://www.selenic.com/mercurial/


Contact
-------

Contact information can be found on my site, [brodierao.com][7].

[7]: http://brodierao.com/
