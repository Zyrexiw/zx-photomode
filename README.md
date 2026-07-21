# zxw_photomode - Photo Mode Freecam

A FiveM photo mode script that provides advanced freecam capabilities with visual filters, zoom, roll, and custom transition points.

## Preview

*(No preview currently)*

## Features

- ✅ Advanced Freecam with smooth movement and rotation
- ✅ Adjustable movement speed, FOV, and camera roll
- ✅ Huge variety of built-in visual filters (Timecycle Modifiers)
- ✅ Custom transition points system for cinematic shots
- ✅ Intuitive UI toggle
- ✅ Configurable maximum distance restrictions
- ✅ Built-in collision support
- ✅ Comprehensive exports for external script integration

## Dependencies

- Standalone (No specific framework required)

## Installation

1. Place the `zx_photomode` folder in your `resources` directory
2. Add `ensure zx_photomode` to your `server.cfg`

## Configuration

Edit `config.lua` to customize:
- Freecam speeds (Movement, Rotation, Zoom, Fast Move)
- Smoothing and FOV limits
- Keybinds and control settings
- Visual filters list
- Admin requirements and maximum distance restrictions
- Marker properties for transition points

## Controls

Based on default configuration (customizable in `config.lua`):
- **Z / S / Q / D** - Move Forward / Backward / Left / Right
- **A / E** - Move Up / Down
- **Shift** - Fast Move Speed
- **Arrow Keys** - Roll Camera
- **Mouse Wheel** - Zoom In / Out
- **O** - Set Transition Point
- **K** - Toggle UI
- **F2** - Quit Photo Mode

## Exports

### Client Exports

- `exports.zx_photomode:startFreecam()` - Starts the photo mode freecam
- `exports.zx_photomode:stopFreecam()` - Stops the freecam
- `exports.zx_photomode:isFreecamActive()` - Returns `true` if freecam is currently active
- `exports.zx_photomode:getFreecamPos()` - Returns the current position of the freecam
- `exports.zx_photomode:setEffects(enabled, strength, near, far, fEnabled, filter, fStrength, sEnabled, sStrength)` - Set visual effects
- `exports.zx_photomode:getEffects()` - Get current visual effects state

## Compatibility

- Standalone (Works with any framework like ESX, QBCore, etc.)

## Support

For issues or questions, please join my discord: https://discord.gg/dJcewbNHbT
