# Fuel Calculator - Developer Guide

## Overview
The Fuel Calculator for Sim Racing is a WordPress plugin that provides comprehensive fuel calculation tools for sim racers. It features both standard (single-stint) and advanced (multi-stint) calculators.

## Plugin Architecture

### Directory Structure
```
fuel-calculator/
├── fuel-calculator.php      # Main plugin file
├── includes/
│   └── class-fuel-calculator.php  # Main plugin class
├── assets/
│   ├── css/
│   │   └── fuel-calculator.css    # Calculator styles
│   └── js/
│       └── fuel-calculator.js     # Calculator logic
├── languages/               # Translation files
├── readme.txt              # WordPress.org readme
├── CHANGELOG.md            # Version history
└── DEVELOPER-GUIDE.md      # This file
```

### Key Components

#### 1. Main Plugin File (`fuel-calculator.php`)
- Registers the plugin with WordPress
- Defines plugin constants
- Sets up activation/deactivation hooks
- Initializes the main plugin class

#### 2. Plugin Class (`includes/class-fuel-calculator.php`)
- Handles shortcode registration: `[fuel_calculator]`
- Manages asset enqueueing (CSS/JS)
- Renders calculator HTML

#### 3. JavaScript (`assets/js/fuel-calculator.js`)
- Pure vanilla JavaScript (no dependencies)
- Handles all calculation logic client-side
- Manages tab switching and UI updates
- Real-time calculation updates

#### 4. Styles (`assets/css/fuel-calculator.css`)
- Dark theme with gradient background
- Fully responsive design
- Custom styling for inputs and results
- Mobile-optimized layout

## Development Workflow

### Local Development
1. Clone to your local WordPress plugins directory
2. Activate the plugin in WordPress admin
3. Use the shortcode `[fuel_calculator]` on any page

### Making Changes
1. **PHP Changes**: Edit files and refresh the page
2. **JavaScript Changes**: Edit `fuel-calculator.js` and hard refresh (Ctrl+F5)
3. **CSS Changes**: Edit `fuel-calculator.css` and hard refresh

### Testing
1. Test standard calculator with various input combinations
2. Test advanced calculator with multiple stints
3. Verify mobile responsiveness
4. Check calculations match expected results

## Calculation Logic

### Standard Calculator
```javascript
// Time-based calculation
const raceTimeSeconds = hours * 3600 + minutes * 60;
const estimatedLaps = Math.ceil(raceTimeSeconds / lapTimeSeconds);

// Lap-based calculation
const totalRaceTime = totalLaps * lapTimeSeconds;

// Fuel calculations
const totalFuel = estimatedLaps * fuelPerLap;
const safeFuel = (estimatedLaps + 2) * fuelPerLap; // 2 extra laps
```

### Advanced Calculator
```javascript
// Maximum laps per stint based on tank capacity
const maxLapsPerStint = Math.floor(tankCapacity / fuelPerLap);

// Each stint can have different lap counts
// Total fuel = sum of all stint fuel requirements
```

## Customization

### Adding New Features
1. **New Input Fields**: Add to HTML in `class-fuel-calculator.php`
2. **New Calculations**: Update logic in `fuel-calculator.js`
3. **New Styling**: Add CSS rules to `fuel-calculator.css`

### Shortcode Attributes
Currently supports:
- `theme` - For future theme variations (default: 'default')

Example: `[fuel_calculator theme="dark"]`

## Translation Support
The plugin is translation-ready:
- Text domain: `fuel-calculator`
- Use `__()` and `_e()` functions for translatable strings
- POT file can be generated using standard WordPress tools

## Browser Support
- Modern browsers (Chrome, Firefox, Safari, Edge)
- IE11 not supported (uses modern JavaScript features)
- Mobile browsers fully supported

## Performance Considerations
- Assets only load on pages with the shortcode
- No external dependencies
- Minimal DOM manipulation
- Efficient event handling

## Future Enhancements
1. Save/load calculator presets
2. Export results to CSV
3. Integration with telemetry data
4. More racing series presets
5. Fuel strategy optimizer

## Support
For issues or feature requests, please contact the plugin author or submit via the WordPress plugin repository.

## License
GPL v2 or later - see LICENSE file for details.
