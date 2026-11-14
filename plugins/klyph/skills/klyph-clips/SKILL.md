---
name: klyph-clips
description: Turn a long video into short clips with Klyph. Use when the user wants to clip, cut, caption or repurpose a video they own (a URL or a local file), check on a Klyph video or render, or download finished clips.
---

# Klyph clips

Klyph clips and edits the user's own videos. It finds the best moments in footage they already have, captions them, and renders MP4s. It does not generate video with AI, so never offer it for that.

Everything runs through the `klyph` MCP server. If its tools are missing or return an auth error, tell the user to run `/mcp` and sign in to Klyph, then carry on.

## Workflow

1. **Check the workspace.** Call `get_workspace`. Tell the user the workspace name and plan so they know which account they're working in.
2. **Pick a project.** Call `list_projects`. Reuse one if it fits. Otherwise `create_project` with a name and optional description. Use `get_project`, `update_project` or `delete_project` only when asked. Deleting is permanent, so confirm first.
3. **Get the video in.**
   - **Public URL:** `import_video` with `project_id` and `url`. It imports in the background.
   - **Local file:** call `create_upload` with `project_id`, `filename`, `file_size` in bytes (and `duration_seconds` if you know it). It returns `video_id` and `signed_url`. Then run:
     ```
     ${CLAUDE_PLUGIN_ROOT}/scripts/klyph-upload.sh "<path>" "<signed_url>"
     ```
     When it exits 0, call `process_video` with the `video_id`.
   - **The user would rather use the browser:** call `get_upload_link` with `project_id` and hand them the link. `start_upload` shows the max file size for their plan.
4. **Process.** `process_video` starts transcription, analysis and clip picking. Useful options: `max_clips` (1 to 10), `min_duration` and `max_duration` in seconds, `aspect_ratio` (for example `9:16`), `language`, and `custom_instructions` for the kind of moments to find. For an imported URL, wait for the import to finish (`get_video_status`) before calling it. Use `reprocess_video` only when the user wants new settings. It replaces earlier clips, so confirm first.
5. **Wait.** Poll `get_video_status` every 20 to 30 seconds and give the user a short update when the stage changes. Processing a long video takes a few minutes. Don't poll faster.
6. **Review the clips.** `list_clips` with the `video_id`, then `get_clip` for details. Show each clip's title, length and why it was picked. Let the user choose what to keep. `delete_clip` removes one for good.
7. **Edit if they want to.** `list_caption_presets` shows the caption styles. `update_clip` can set `caption_preset_id` or turn captions on and off with `caption_enabled`. That is the full edit surface for now, so don't promise trims or layout changes.
8. **Render.** `render_clip` with the `clip_id` (MP4). Poll `get_render_progress` the same way as step 5.
9. **Hand over.** `get_clip_download_url` returns a signed link that expires. Give it to the user right away, and say it won't last.

## Other video tools

- `list_videos`: list videos, optionally filtered by `project_id` or `status`. Use it to find a video the user mentions by name.
- `get_video`: details for one video by `video_id`.
- `delete_video`: permanently deletes a video, its clips and its files. Only on explicit request, and confirm with the user first.

## Things that go wrong

- **Plan limits.** Free and lower tiers cap file size, video length and monthly usage. If a tool returns a limit error, pass the message on in plain words and stop. Mention the plans page on klyph.ai only if they ask about limits. Don't retry in a loop.
- **Expired upload URL.** Signed upload URLs last about two hours. If the upload fails after a long wait, call `create_upload` again.
- **Failed processing.** If `get_video_status` shows `failed`, say so, show any error it gives, and offer `reprocess_video`.
- **Rate limits.** If a tool says to wait, wait, then retry once.

## Style

Keep updates short. Say what's happening and what's next. Don't dump raw JSON on the user.
