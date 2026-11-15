---
description: Clip a video with Klyph. Pass a public URL or a path to a local file.
argument-hint: <video-url-or-file-path>
---

Use the klyph-clips skill to turn this video into short clips: $ARGUMENTS

If no argument was given, ask the user for a public video URL or a path to a local file.

Run the whole flow: check the workspace, pick or create a project, get the video in with the user's clip settings (import for a URL, which also starts processing; upload then process for a local file), let it run, and show the clips. Ask before exporting anything, then export the clips the user picks with `render_clip` and give them the finished links.
