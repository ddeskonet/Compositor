# dmgbuild settings for the DMG window: the same layout scripts/release.sh gives create-dmg,
# written straight into .DS_Store so it works on a CI runner without driving Finder.
# Run: dmgbuild -s dmgbuild-settings.py -D app=path/Compositor.app -D background=bg.tiff Compositor out.dmg
import os.path

app = defines["app"]  # noqa: F821 (dmgbuild supplies `defines`)
app_name = os.path.basename(app)

files = [app]
symlinks = {"Applications": "/Applications"}
hide_extensions = [app_name]

background = defines.get("background", "builtin-arrow")  # noqa: F821
window_rect = ((200, 120), (600, 380))
default_view = "icon-view"
show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False
show_sidebar = False

icon_size = 128
text_size = 13
icon_locations = {app_name: (160, 180), "Applications": (440, 180)}

format = "UDZO"
filesystem = "HFS+"
