# Open edX Brand Package Interface

This project contains the default branding assets and style used in Open edX
applications. It is published on npm as `@openedx/brand-openedx`.

The file structure serves as an interface to be implemented for custom
branding and theming of Open edX.

## How to use this package

Applications in Open edX are configured by default to include this
package for branding assets and theming visual style.

To use a custom brand and theme\...

1.  Fork or copy this project. Ensure that it lives in a location
    accessible to Open edX applications during asset builds. This may be
    a published git repo, npm, or local folder depending on your
    situation.
2.  Replace the assets in this project with your own logos and design
    tokens. Match the filenames exactly. Open edX applications refer to
    these files by their filepath. Refer to the brand for edx.org at
    <https://github.com/edx/brand> for an example.

    Theme customization is driven by design tokens; follow the guide at
    [Paragon Design Tokens Compatibility](./docs/how-to/design-tokens-support.rst).

3.  Configure your Open edX instance to consume your custom brand
    package. Refer to this documentation on configuring the platform:
    https://docs.openedx.org/projects/openedx-proposals/en/latest/architectural-decisions/oep-0048-brand-customization.html
    \[TODO: Add a link to documentation on configuring in Open edX MFE
    pipelines when it exists\]
4.  Rebuild the assets and microfrontends in your Open edX instance to
    see the new brand reflected. \[TODO: Add link to relevant
    documentation when it is completed\].

### Installing from Git in MFEs (`npm install @edx/brand@git+...`)

Microfrontends load theme CSS from `dist/` via `dist/theme-urls.json` (see
`@openedx/frontend-build` Paragon webpack plugin). That directory is produced by
`npm run build` / `make build`.

When you depend on a **git ref**, either:

1. **Commit `dist/`** on the release branch/tag (recommended), then reinstall; or
2. Run **`npm run build`** inside `node_modules/@edx/brand` after install.

The `prepare` script builds `dist/` automatically when it is missing. For Tutor
deployments, also set `MFE_CONFIG["PARAGON_THEME_URLS"]` to raw GitHub URLs under
`dist/` (see `tutor-plugins-local/mfe_mylango_branding.py`).

## Files this package must make available

`/logo.svg`

![logo](/logo.svg)

`/logo-trademark.svg` A variant of the logo with a trademark ® or ™.
Note: This file must be present. If you don\'t have a trademark variant
of your logo, copy your regular logo and use that.

![logo](/logo-trademark.svg)

`/logo-white.svg` A variant of the logo for use on dark backgrounds

![logo](/logo-white.svg)

`/favicon.ico` A site favicon

![favicon](/favicon.ico)

`/paragon/images/card-imagecap-fallback.png` A variant of the default
fallback image for [Card.ImageCap] component.

![card-imagecap-fallback](/paragon/images/card-imagecap-fallback.png)

`/core.min.css` (and `/core.css`) Brand-layer core CSS bundle, assembled
from `paragon/core.scss` by `paragon build-scss` at publish time.
Consumers import this on top of Paragon's own core CSS.

`/light.min.css` (and `/light.css`) Light theme variant CSS bundle,
assembled from the token outputs at `paragon/build/themes/light/`.
Consumers import this for the light theme.

## Source files (for forks customizing the brand)

These files live in this repo as inputs to the build; they are not
shipped in the published package.

`/paragon/core.scss` Assembly point consumed by `paragon build-scss` and
emitted as the published `core.min.css`. Its job is to `@use` the
token-generated CSS at `./build/core/...` so that those custom
properties end up in the bundle consumers download. With Paragon 23
this is not where brand customizations go (use design tokens for that),
but it is the place for non-tokenizable additions such as custom
`@media` rules, or brand-specific selectors that don't map to Paragon
components.

`/paragon/_fonts.scss` SASS partial for `@import` rules that load web
fonts referenced by tokens (e.g. Google Fonts URLs).

`/paragon/tokens/core/<category>/*.json`,
`/paragon/tokens/themes/<variant>/*.json` Design token overrides in
[Style Dictionary](https://styledictionary.com/) format, and the sole
supported way to customize the theme with Paragon 23. Files under
`core/` override Paragon's core tokens (typography, spacing,
breakpoints, etc.); files under `themes/<variant>/` override
theme-variant tokens (colors, component values) for that variant
(currently `light`). See
[Paragon Design Tokens Compatibility](./docs/how-to/design-tokens-support.rst).

## Customizing typography and fonts (MFE apps)

This section is the **client-change guide** for MFE typography. MFEs load
`@edx/brand` CSS on top of Paragon; edits here affect learner-dashboard,
learning, account, authn, authoring, etc. after you rebuild and redeploy.

**LMS / Studio classic UI** (course about pages, legacy dashboard HTML) uses
**tutor-indigo** Sass under `tutor-indigo/tutorindigo/templates/indigo/lms/static/sass/`
— not this package. Change both places if the client wants one look everywhere.

### Quick reference — what to edit

| Client wants to change… | Edit this file | Token / CSS variable (after build) |
| --------------------- | -------------- | ------------------------------------ |
| Font families (body, UI) | `paragon/tokens/core/global/typography.json` → `font.family.sans.serif` | `--pgn-typography-font-family-sans-serif` |
| Heading font (titles, `h1`–`h6`) | `paragon/tokens/core/components/general/headings.json` → `headings.font.family` | `--pgn-typography-headings-font-family` |
| Body text size | `paragon/tokens/core/global/typography.json` → `font.size.base` | `--pgn-typography-font-size-base` |
| Button / input text size | `paragon/tokens/core/components/general/input.json` → `input.btn.font.size` | `--pgn-typography-input-btn-font-size-base` (and `-sm`, `-lg`) |
| Heading weight (`h1`–`h6`) | `paragon/tokens/core/components/general/headings.json` → `headings.font.weight` | `--pgn-typography-headings-font-weight` |
| MFE header nav + course card title weight | `paragon/core.scss` (see comments) | Uses `--pgn-typography-font-weight-semi-bold` |
| Google Fonts URL / weights loaded | `paragon/_fonts.scss` | N/A (update families in tokens to match) |
| Brand colors (primary, secondary, muted) | `paragon/tokens/themes/light/global/openedx-cms-theme.json` | `--pgn-color-primary-base`, etc. |
| Navbar logo size (MFE only) | `tutor-plugins-local/mfe_mylango_logo_slot.py` → `MyLangGoLogo` `<style>` block | CSS in plugin (not in this repo) |

### Current MyLanGo values (aligned with tutor-indigo + openedx-cms)

These are the **defaults in this fork** so MFEs feel closer to indigo than stock Paragon.

| Setting | This repo | Paragon 23 default | tutor-indigo LMS (typical) |
| ------- | --------- | ------------------ | --------------------------- |
| Body font size | `1rem` (16px) | `1.125rem` (18px) | ~14–16px in nav/body Sass |
| Button/input base | `1rem` | `1.125rem` | — |
| Button/input small | `0.875rem` (14px) | `0.875rem` | Nav links often 14px |
| Heading weight | `500` (medium) | `700` (bold) | Nav/labels often `500` |
| Card title weight | `500` (via `core.scss`) | `700` | — |
| Body font | Inter | System stack | Inter (indigo theme) |
| Headings font | Outfit, then Inter | Inherits body | Outfit (indigo theme) |

Heading **sizes** (`h1`–`h6`) are **not** overridden in this fork; Paragon defaults apply
(e.g. `h1` = `2.5rem`). To shrink or enlarge headings only, add overrides under
`paragon/tokens/core/global/typography.json` → `font.size.h1.base`, `h2.base`, etc.
(see [Paragon tokens](https://github.com/openedx/paragon/tree/release-23.x/tokens/src/core/global/typography.json)
for property names).

### File-by-file guide

#### 1. `paragon/_fonts.scss`

Loads web fonts. Keep the `family=` weights in sync with what you use in tokens
(e.g. if headings use Outfit 600, include `wght@600` in the Outfit URL).

```scss
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;500;600;700&...');
```

#### 2. `paragon/tokens/core/global/typography.json`

- **`font.family.sans.serif`** — body/UI font stack (default: Inter).
- **`font.size.base`** — main body size (default: `1rem`). Changing this scales
  most UI that inherits body text.

Example — larger body for a client:

```json
"base": {
  "source": "$font-size-base",
  "$value": "1.125rem",
  "$description": "Client request: 18px body."
}
```

Example — add smaller `h4` only:

```json
"h4": {
  "base": {
    "source": "$h4-font-size",
    "$value": "1.125rem"
  }
}
```

#### 3. `paragon/tokens/core/components/general/headings.json`

- **`headings.font.family`** — font for `h1`–`h6` (default: Outfit, Inter, …).
- **`headings.font.weight`** — default `{typography.font.weight.semi.bold}` → **500**.
  For bolder headings use `{typography.font.weight.bold}` → **700**.

#### 4. `paragon/tokens/core/components/general/input.json`

Button and form control text sizes:

- **`base`** — default `1rem`
- **`sm`** — default `0.875rem`
- **`lg`** — default `1.125rem`

#### 5. `paragon/core.scss`

Use when a component **does not** expose a token (Paragon card titles use
`font-weight-bold` in SCSS). Edit the selectors and properties here.

Current rules:

- `.main-nav .nav-link` / `.secondary-menu-container .nav-link` → weight 500
- `.pgn__card-header-title*` / `.course-card-title` → weight 500

To make card titles bold again, set `font-weight: var(--pgn-typography-font-weight-bold);`
or remove those blocks.

#### 6. `paragon/tokens/themes/light/global/openedx-cms-theme.json`

Colors only (not font size). Matches marketing site / openedx-cms palette.

### Build and deploy after font changes

```bash
cd brand-openedx
make build                    # regenerates paragon/build/ and dist/
git add paragon/tokens/ paragon/core.scss paragon/_fonts.scss dist/
git commit -m "Typography: <short client note>"
git push
```

**Tutor / production MFEs** (see also `tutor-plugins-local/README.md`):

```bash
# Point MYLANGO_BRAND_PACKAGE / MYLANGO_BRAND_CSS_BASE_URL at your git ref if needed
tutor images build mfe
tutor config save
tutor local start -d
```

**Local MFE dev** (`npm install @edx/brand@git+...`):

```bash
cd node_modules/@edx/brand && npm ci && npm run build
# restart the MFE dev server (e.g. npm run dev)
```

### Verify changes

After `make build`, inspect generated variables:

```bash
grep -E 'font-size-base|headings-font-weight|input-btn-font-size' paragon/build/core/variables.css
```

In the browser, check computed styles on:

- MFE header links (learner-dashboard → Courses / Discover New)
- Course card title on the dashboard
- A plain paragraph (body size)

### Related repos

| Area | Where fonts are defined |
| ---- | ------------------------ |
| MFE Paragon theme | **This repo** (`brand-openedx`) |
| MFE logos only | `tutor-plugins-local/mfe_logo_urls_patch.py`, `openedx-cms/scripts/generate-mfe-logo.sh` |
| LMS + Studio (indigo) | `tutor-indigo/.../static/sass/` (e.g. `_header.scss`, `_dashboard.scss`, `_fonts.scss`) |
| Marketing site | `openedx-cms/src/app/globals.css`, `layout.tsx` (Tailwind) |
