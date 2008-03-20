SafariSingleWindow
==================

SafariSingleWindow is a [SIMBL][1] plugin for [Safari][2] that forces all
links that would open in new windows to open in new tabs instead.

No configuration is necessary, just install SIMBL and move
`SafariSingleWindow.bundle` to `Library/Application Support/SIMBL/Plugins` in
your home folder and restart Safari. To uninstall the plugin, simply delete
the plugin's folder.

If you experience any problems, check Console for lines starting with
`[SafariSingleWindow]`. If you see any, copy them and email them to me,
and I'll see what I can do to fix it.

[1]: http://www.culater.net/software/SIMBL/SIMBL.php
[2]: http://www.apple.com/safari/


Download
--------

[SafariSingleWindow.zip][3] (15 KB)

[3]: http://bitheap.org/singlewindow/SafariSingleWindow.zip


Development
-----------

Download the official development repository using [Mercurial][4]:

    hg clone http://bitheap.org/hg/safarisinglewindow/ safarisinglewindow

Run `make` to compile the plugin, and `make install` to install it into
your home directory's SIMBL plugins folder.

[4]: http://www.selenic.com/mercurial/


Contact
-------

Contact information can be found on my site, [brodierao.com][5].

[5]: http://brodierao.com/
