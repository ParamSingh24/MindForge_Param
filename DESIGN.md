# Design System Specification: The Ethereal Ledger

## 1. Overview & Creative North Star
**Creative North Star: The Ethereal Ledger**
This design system moves away from the rigid, spreadsheet-like density of traditional financial tools. Instead, it adopts an editorial philosophy where data is treated with the reverence of a high-end gallery catalog. By prioritizing "breathing room," intentional asymmetry, and tonal layering, we create a premium environment that feels both sophisticated and effortless.

The goal is to break the "template" look. We achieve this by avoiding heavy containment and instead using shifting light and soft depth to guide the eye. This is a system built on clarity, where "premium" is defined by what is left out as much as what is put in.

---

## 2. Colors & Tonal Architecture
The palette is a sophisticated interplay of light-drenched neutrals and vibrant jewel-toned accents.

### The Palette
- **Primary (`#6834eb`):** Used for primary actions and focused brand expressions. Use the `primary_container` (`#c8b7ff`) for high-reach background elements to maintain an airy feel.
- **Secondary (`#006e2a`):** Represents growth and positive financial trends. It should be used sparingly to highlight "success" states.
- **Surface & Background (`#f8f9fe`):** A cool, tinted white that prevents the "starkness" of pure white, providing a softer canvas for the eyes.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section content. Boundaries must be defined solely through background color shifts. For example, a `surface_container_low` section sitting on a `surface` background creates a natural, soft edge that feels integrated rather than walled off.

### The Glass & Gradient Rule
To move beyond a flat "Material" look, utilize **Glassmorphism**. Floating elements (like navigation bars or modal headers) should use semi-transparent versions of `surface_container_lowest` with a `backdrop-filter: blur(20px)`. 
- **Signature Textures:** Apply subtle linear gradients transitioning from `primary` to `primary_dim` for main CTAs to add "soul" and a sense of light source.

---

## 3. Typography
The typography system uses a dual-typeface approach to balance authority with approachability.

- **Display & Headlines (Plus Jakarta Sans):** These are the "Editorial" voice. Use `display-lg` and `headline-md` for high-impact numbers and page titles. The bold weights of Plus Jakarta Sans provide a sense of security and modernism.
- **Body & Labels (Manrope):** Chosen for its exceptional legibility in dense data environments. Use `body-md` for standard descriptions and `label-sm` for micro-data.

**Hierarchy Strategy:** 
Use extreme scale contrast. A large `display-sm` balance amount should be paired with a much smaller, lighter `label-md` currency indicator. This "High-Low" pairing is a hallmark of high-end editorial design.

---

## 4. Elevation & Depth
In this system, depth is conveyed through **Tonal Layering** rather than structural scaffolding.

### The Layering Principle
Depth is achieved by "stacking" surface tiers. 
1. **Base:** `surface` (#f8f9fe)
2. **Sectioning:** `surface_container_low` (#f1f3f9)
3. **Interactive Cards:** `surface_container_lowest` (#ffffff)

This stacking creates a soft, natural lift. By placing a white card on a slightly grey-blue background, the eye perceives elevation without the need for a heavy shadow.

### Ambient Shadows
When a "floating" effect is required for high-priority elements:
- Use **extra-diffused shadows** (Blur: 32px—64px).
- **Opacity:** 4% to 8%.
- **Tinting:** Never use pure black for shadows. Use a 10% opacity version of `on_surface` (#2d333a) to mimic natural ambient light.

### The "Ghost Border" Fallback
If a border is absolutely necessary for accessibility, use a **Ghost Border**: the `outline_variant` token at 15% opacity. Never use 100% opaque, high-contrast borders.

---

## 5. Components

### Buttons
- **Primary:** High-gloss `primary` (#6834eb) with `on_primary` text. Use `xl` (1.5rem) roundedness to create a friendly, organic shape.
- **Secondary:** `surface_container_high` background with `primary` text. No border.

### Cards & Data Visualization
- **Cards:** Use `surface_container_lowest` for the card body. Use the `lg` (1rem) corner radius. **Forbid the use of divider lines.** Separate content using vertical white space (1.5rem–2rem) or subtle background shifts.
- **Progress Bars:** Use `primary` for the active state and `primary_container` for the track. Ensure the ends are `full` rounded.

### Input Fields
- Avoid "box" inputs. Use a `surface_container_low` background with a `sm` (0.25rem) bottom-only accent in `primary` when focused. This maintains the "airy" feel while providing clear feedback.

### Navigation (The Floating Dock)
The bottom navigation should not be pinned to the bottom of the screen. Treat it as a floating "dock" using Glassmorphism, with `xl` (1.5rem) rounded corners and an ambient shadow.

---

## 6. Do's and Don'ts

### Do
- **DO** use generous white space. If you think there is enough space, add 8px more.
- **DO** use `secondary` (#006e2a) for positive financial indicators (e.g., +$120.00).
- **DO** overlap elements slightly (e.g., a card overlapping a background gradient) to create a sense of bespoke layering.
- **DO** use "Bold" weights for primary financial figures to ensure high readability.

### Don't
- **DON'T** use 1px dividers to separate list items. Use 16px of vertical padding instead.
- **DON'T** use pure black (#000000). Always use `on_surface` (#2d333a) for text to maintain the soft, premium feel.
- **DON'T** use sharp 90-degree corners. Everything must have at least the `sm` (0.25rem) radius to feel "approachable."
- **DON'T** clutter the UI. If a piece of information isn't vital to the current task, move it to a secondary layer.
