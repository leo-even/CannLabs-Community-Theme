# CannLabs Community theme

The Discourse theme for CannLabs Community (`leo-even/CannLabs-Community`). It is a full theme on core / Foundation styling.

Version 0.1.0 is a development version, not a production release.

## What it covers

- Header, desktop sidebar and mobile drawer.
- `/latest` and `/categories`.
- Two paired colour schemes: "CannLabs Comunidade Claro" (light) and "CannLabs Comunidade Escuro" (dark).

It adds no JavaScript, theme settings, locales or components, and it never writes site settings, uploads or category data.

The scheme names are frozen: light/dark pairing (`only_theme_color_schemes`) happens only on the first install.

## Layout

| Path | Contents |
| --- | --- |
| `about.json` | Metadata and the two colour schemes |
| `common/color_definitions.scss` | Per-scheme raw values as `--cl-*` variables |
| `common/common.scss` | Imports only |
| `scss/_fonts.scss` | Font stacks; `@font-face` pattern, inactive until binaries are authorized |
| `scss/_tokens.scss` | Global shape tokens |
| `scss/_shell.scss` | Header, sidebar and drawer |
| `scss/_topic-list.scss` | Topic list and filter row |
| `scss/_categories.scss` | Category list |
| `scss/_focus.scss` | Focus ring for the scoped surfaces |
| `spec/system/` | Theme system specs |

Variables that modernize redeclares on `<body>` are set at component scope, never on `:root`.

## Fonts

No font binaries are bundled yet, so every stack falls back to system fonts.

Before any font file is added, it needs a provenance record: source, exact version, sha256 and the retained OFL licence.

Topic-list titles use `--cl-font-title`, declared once in `scss/_topic-list.scss`:

- `var(--cl-font-serif)` for Petrona, the current hypothesis;
- `var(--cl-font-sans)` for Public Sans.

## Install

Install from the git URL through the standard Discourse theme installer, pinned to a reviewed commit.

- Admin UI: **Customize → Themes → Install → From a git repository**, URL `https://github.com/leo-even/CannLabs-Community-Theme`.
- Or:

  ```ruby
  RemoteTheme.import_theme("https://github.com/leo-even/CannLabs-Community-Theme", Discourse.system_user)
  ```

Then check that the installed commit is the reviewed one:

```ruby
Theme.find_by(name: "CannLabs Community").remote_theme.local_version
```

The site logo, title, locale and category data are site configuration, not part of this theme.

## Update

Updates are manual and explicit; there is no automatic update.

1. Review the new commit.
2. Update the theme from its remote: **Customize → Themes → CannLabs Community → Check for updates**, or `RemoteTheme#update_from_remote`.
3. Confirm `remote_theme.local_version` matches the reviewed commit.

## Rollback

1. **First line:** set the default theme back to Foundation. The theme stays installed and nothing is deleted.
2. **Second line:** re-pin to the previous validated commit.
3. **Configuration:** restore the recorded `logo`, `mobile_logo`, `logo_dark`, `mobile_logo_dark` and `logo_small` values, and any category changes, from the pre-change record.
4. There are no data migrations. The colour schemes stay in the database, harmless when the theme is not the default.
5. Never rename the colour schemes.

## Checks

The linters use the shared Discourse configs (`@discourse/lint-configs`):

```sh
pnpm install
pnpm lint
```

System specs run from a Discourse checkout, with this theme cloned under its `tmp/themes/`:

```sh
bin/rspec tmp/themes/cannlabs-community-theme/spec/system
```
