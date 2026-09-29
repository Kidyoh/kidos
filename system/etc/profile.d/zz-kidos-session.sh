# Start the KidOS desktop when a normal user logs in on tty1.
# If Sway exits or crashes you land in a shell, not a login loop.
# (Named zz- so every other profile.d script runs first.)
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] && [ "$(id -u)" -ne 0 ]; then
    kidos-session
fi
