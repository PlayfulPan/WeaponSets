
# WeaponSets

Provides commands for creating/updating weapon sets using the built-in equipment manager in Classic World of Warcraft.

## Installation (Classic)
1. Download **`WeaponSets.zip`** from the GitHub Releases page.
2. Extract so you have a single folder (e.g., **`WeaponSets/`**).
3. Move that folder to: `World of Warcraft/_classic_era_/Interface/AddOns/`
4. In-game, enable the addon (check **Load out of date AddOns** if needed) and `/reload`.

## Usage

```
/ws list                   - list equipment sets
/ws create "<name>"        - create new MH/OH-only set (fails if name exists)
/ws update "<name>"        - update existing set to current MH/OH (MH/OH-only)
/ws delete "<name>"        - delete set by name
```
- Quotes are only needed if the name contains spaces.
- “MH/OH-only” saves only **slot 16** (Main-Hand) and **slot 17** (Off-Hand).

