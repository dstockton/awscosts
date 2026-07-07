# 🧩 Twisted Corner Detector

A single-file, offline SPA that uses a phone camera to scan a Rubik's cube,
determine whether it is physically solvable, and — if a corner has been
twisted the wrong way (the classic "reassembled cube that can't be solved"
bug) — tell you **which corner** and **which direction to twist it back**.

Open [`index.html`](index.html) — that's the whole app. No build step, no
dependencies, nothing is uploaded.

> **2×2 (Pocket Cube)?** There's a dedicated version in [`2x2/`](2x2/index.html)
> (served at `/awscosts/2x2/`). A 2×2 has no centres — colours are learned by
> clustering all 24 stickers — and no edges or permutation constraint, so a
> **twisted corner is the only thing** that can make it unsolvable.

## Using it on your phone

The camera API requires a secure context (HTTPS or `localhost`). Easiest options:

- **GitHub Pages / any static host** — serve the `rubiks-corner-detector/`
  folder and open it on your phone.
- **Local test** — `cd rubiks-corner-detector && python3 -m http.server`,
  then browse from the same machine at `http://localhost:8000`.
- No camera? Use **"Enter cube manually"** and tap the net to fill in colors.

## How it works

1. **Scan** all six faces one at a time following the on-screen prompts. The
   overlay shows the 3×3 sampling grid.
2. **Color calibration** is learned from each face's *center* sticker, then
   every sticker is classified to its nearest center. Because it never
   hardcodes color names, it doesn't matter that this cube's "white" stickers
   are actually **black** — it just calibrates to whatever the camera sees.
3. **Correct** any misread square by tapping it in the unfolded net; the
   analysis re-runs live.
4. **Analysis** builds the standard 54-facelet (Kociemba) model and checks the
   three solvability invariants:
   - **Corner-orientation parity** — the sum of all 8 corner orientations must
     be ≡ 0 (mod 3). A non-zero total means a corner is physically twisted.
   - **Edge-flip parity** — sum of edge orientations must be ≡ 0 (mod 2).
   - **Permutation parity** — corner and edge permutation parities must match
     (a single swap is impossible on an intact cube).
5. **Fix guidance:**
   - If the cube is otherwise solved, the twisted corner(s) are pinpointed by
     their colors and each gets a clockwise / counter-clockwise instruction.
   - If the cube is scrambled, the twist is a whole-cube invariant, so it tells
     you the net direction to twist any one corner to zero out the parity, and
     highlights candidate corners in the net.

## Notes & limitations

- Camera color detection depends on lighting; red vs. orange and dark colors
  are the usual trouble spots — that's what the tap-to-correct net is for.
- Detecting *which specific* corner was tampered with is only unambiguous when
  the cube is solved apart from the twist. On a full scramble the twist is a
  global property, so the tool reports the net defect and how to neutralise it.
