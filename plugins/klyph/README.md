# Klyph for Claude Code

Klyph turns long videos into short clips. This plugin lets you do it from Claude Code: point it at a video, and it finds the best moments, captions them, and renders MP4s you can post.

Klyph clips and edits your own videos. It is not AI video generation, and it never invents footage.

## Install

```
/plugin marketplace add Klyph-AI/claude-plugin
/plugin install klyph@klyph
```

Then run `/mcp`, pick `klyph`, and sign in with your Klyph account. Sign-in needs Claude Code 2.1.325 or later, and opens a browser window on `localhost:33418`. You need a Klyph account. Sign up at https://klyph.ai.

## Use it in the Claude app (claude.ai, Desktop, mobile)

**Installed this plugin in the Claude app?** Open **Settings → Connectors**, find **Klyph**, click **Connect**, sign in and pick the workspace Claude can use.

**Not using the plugin?** Add Klyph as a custom connector:

1. In claude.ai, open **Settings → Connectors → Add custom connector**.
2. Name: `Klyph`. URL: `https://app.klyph.ai/api/mcp`.
3. Click **Connect**, sign in to Klyph and pick the workspace Claude can use.

The connector then works in Claude Desktop and the mobile apps too. Until Klyph is in Claude's connector directory, Claude labels it "Unverified".

## Use it

Ask in plain words:

- "Clip this podcast into the five best moments: https://example.com/episode.mp4"
- "Upload ~/Videos/webinar.mov to Klyph and make 9:16 clips"
- "Is my last video done processing?"

Or run the command:

```
/klyph:clip <video-url-or-file-path>
```

## What it can do

- Create and manage projects
- Import a video from a public URL, or upload a local file
- Process a video and pick clips, with limits for length, count and language
- Switch caption styles and turn captions on or off
- Render clips and give you download links

## Privacy

The plugin sends your requests and the videos you choose to your Klyph account over HTTPS, and nothing else. Requests go to the Klyph connector at `app.klyph.ai`. When you upload a local file, the file goes straight to Klyph's video storage at `fnylzwbbtxtdqswcmvsn.supabase.co`, using a one-time upload link from your account. Klyph keeps your videos, transcripts and clips until you delete them. It stores no keys on your machine. Sign-in uses OAuth, and you can disconnect it any time from Klyph settings.

- Privacy policy: https://klyph.ai/privacy
- Terms: https://klyph.ai/terms
- Support: https://klyph.ai/support (support@klyph.ai)

## License

MIT
