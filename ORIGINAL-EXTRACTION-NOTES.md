# Fuel Calculator Integration - Developer Handover

## Overview
This document provides guidance for integrating the extracted Pitskill.io fuel calculator into a WordPress plugin. The calculator has been reverse-engineered from their React implementation and converted to vanilla JavaScript for easier WordPress integration.

## Source Analysis

### Original Implementation (Pitskill.io)
- **Framework**: React with Material-UI components
- **State Management**: React hooks (useState)
- **Styling**: CSS-in-JS with Material-UI theme
- **Bundle**: Minified as part of main.c89e88f9.js
- **API**: No external API calls - all calculations are client-side

### Extracted Implementation
- **Framework**: Vanilla JavaScript (no dependencies)
- **Styling**: Inline CSS in HTML file
- **Structure**: Modular with clear separation of concerns

## Core Functionality

### 1. Standard Calculator
```javascript
// Key calculation logic
const raceTimeSeconds = hours * 3600 + minutes * 60;
const estimatedLaps = Math.ceil(raceTimeSeconds / lapTimeSeconds);
const totalFuel = estimatedLaps * fuelPerLap;
const safeFuel = (estimatedLaps + extraLaps) * fuelPerLap;
```

### 2. Advanced Calculator
```javascript
// Stint-based calculations
const maxLapsPerStint = Math.floor(tankCapacity / fuelPerLap);
// Multiple stints tracked independently
```

## WordPress Integration Recommendations

### 1. Plugin Structure
```
your-plugin/
├── includes/
│   ├── class-fuel-calculator.php       # Main calculator class
│   ├── class-fuel-calculator-ajax.php  # AJAX handlers
│   └── class-fuel-calculator-shortcode.php
├── assets/
│   ├── js/
│   │   └── fuel-calculator.js         # Adapted JS
│   └── css/
│       └── fuel-calculator.css        # Extracted styles
└── templates/
    └── fuel-calculator-template.php    # HTML template
```

### 2. Shortcode Implementation
```php
// Suggested shortcode: [fuel_calculator]
// With options: [fuel_calculator mode="standard" theme="dark"]
```

### 3. Key Modifications Needed

#### A. WordPress-ify the JavaScript
```javascript
// Original
document.getElementById('raceHours').addEventListener('input', calculateStandard);

// WordPress version
jQuery(document).ready(function($) {
    $('#raceHours').on('input', calculateStandard);
});
```

#### B. Add Nonce Security for AJAX (if needed)
```php
wp_localize_script('fuel-calculator', 'fuel_calc_ajax', array(
    'ajax_url' => admin_url('admin-ajax.php'),
    'nonce' => wp_create_nonce('fuel_calculator_nonce')
));
```

#### C. Make Styling Theme-Compatible
- Extract inline styles to separate CSS file
- Add CSS class prefixes to avoid conflicts
- Consider adding filter hooks for customisation

### 4. Database Considerations
The current implementation is stateless, but you might want to add:
- Save/load fuel strategies
- User preferences (default values)
- Race history tracking

```sql
-- Suggested table structure if needed
CREATE TABLE {$wpdb->prefix}fuel_calculations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    calculation_type VARCHAR(20),
    race_data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Enhancement Opportunities

#### A. Add WordPress-specific Features
- **User Meta**: Save preferred fuel units (litres/gallons)
- **Admin Settings**: Global defaults for calculations
- **Multisite Support**: Per-site configurations
- **Localisation**: Prepare strings for translation

#### B. Additional Calculators
- Tyre degradation calculator
- Pit stop strategy optimizer
- Weather-adjusted fuel consumption

#### C. Data Export Options
- CSV export for race engineers
- Print-friendly layout
- Share via URL parameters

### 6. Code Quality Considerations

#### A. Sanitisation & Validation
```php
// All inputs need sanitisation
$race_hours = absint($_POST['race_hours']);
$fuel_per_lap = floatval($_POST['fuel_per_lap']);
```

#### B. Escaping Output
```php
echo esc_html($calculated_fuel);
echo esc_attr($css_class);
```

#### C. JavaScript Enqueuing
```php
wp_enqueue_script(
    'fuel-calculator',
    plugin_dir_url(__FILE__) . 'assets/js/fuel-calculator.js',
    array('jquery'),
    '1.0.0',
    true
);
```

### 7. Testing Checklist

- [ ] Test with various themes (Twenty Twenty-One, etc.)
- [ ] Verify mobile responsiveness
- [ ] Check calculation accuracy against original
- [ ] Test with different number formats (1.5 vs 1,5)
- [ ] Verify accessibility (ARIA labels, keyboard nav)
- [ ] Test in different browsers
- [ ] Check for JavaScript conflicts with other plugins

### 8. Performance Optimisation

- Consider lazy-loading for advanced calculator
- Minimise DOM queries by caching elements
- Debounce input events for real-time calculations
- Use WordPress transients if adding saved calculations

### 9. Documentation Needs

1. **User Documentation**:
   - How to use the shortcode
   - Explanation of calculations
   - Troubleshooting guide

2. **Developer Documentation**:
   - Filter/action hooks
   - JavaScript events
   - CSS class reference

### 10. Specific Implementation Notes

#### State Management
The original React version uses hooks for state. In the vanilla version, state is managed through:
- DOM element values
- Global variables for stint tracking
- Event-driven updates

#### Styling Approach
- Original uses Material-UI's sx prop and emotion
- Extracted version uses traditional CSS
- Colour scheme: #ff4b2b (orange), #141414 (dark bg), #202020 (card bg)

#### Mobile Handling
- Breakpoint at 600px (consider using WordPress's built-in breakpoints)
- Touch-friendly inputs
- Responsive grid layout

## Migration Path

1. **Phase 1**: Direct integration (copy functionality as-is)
2. **Phase 2**: WordPress enhancement (add saves, user prefs)
3. **Phase 3**: Extended features (multiple calculators, API)

## Questions to Address

1. Should calculations be saved to user profiles?
2. Do we need an admin interface for default values?
3. Should this integrate with any existing race logging plugins?
4. Are there any licensing concerns with the recreation?
5. Do we need to support imperial units (gallons)?

## File Locations & Testing

### Extracted Files Location
All files are located at: `C:\dev\wp\fuel-calculator\`
- `fuel-calculator.html` - Complete HTML with embedded CSS
- `fuel-calculator.js` - JavaScript logic
- `README.md` - Basic documentation
- `DEVELOPER_HANDOVER.md` - This document

### Testing the Existing Code

#### Quick Test Method
1. Open File Explorer and navigate to `C:\dev\wp\fuel-calculator\`
2. Double-click `fuel-calculator.html` to open in your default browser
3. Alternatively, right-click → "Open with" → Choose your preferred browser

#### Local Server Test (Recommended)
```bash
# Navigate to the directory
cd C:\dev\wp\fuel-calculator\

# Using Python (if installed)
python -m http.server 8000
# Then visit: http://localhost:8000/fuel-calculator.html

# Using Node.js (if installed)
npx http-server
# Then visit: http://localhost:8080/fuel-calculator.html

# Using PHP (if installed)
php -S localhost:8000
# Then visit: http://localhost:8000/fuel-calculator.html
```

### Functionality Test Checklist

#### Standard Calculator Tests
1. **Time-based calculation**:
   - Set Race Length: 1 hour, 30 minutes
   - Set Lap Time: 1 minute, 45 seconds
   - Set Fuel Per Lap: 2.8 litres
   - Expected: ~51 laps, ~142.8L fuel needed

2. **Lap-based calculation**:
   - Toggle "Use Laps Instead of Time"
   - Set Race Laps: 50
   - Set Fuel Per Lap: 3.2 litres
   - Expected: 160L fuel needed, 166.4L safe fuel (with 2 extra laps)

3. **Real-time updates**:
   - Change any input value
   - Results should update immediately without page refresh

#### Advanced Calculator Tests
1. **Single stint**:
   - Tank Capacity: 100 litres
   - Fuel Per Lap: 2.5 litres
   - Stint 1: 30 laps, 80 litres
   - Should show: Maximum 40 laps possible (100L ÷ 2.5L)

2. **Multiple stints**:
   - Add 3 stints with different fuel loads
   - Verify total calculations sum correctly
   - Test "Remove" button on stints 2 and 3

### Browser Compatibility Testing
Test in:
- Chrome/Edge (Chromium-based)
- Firefox
- Safari (if on Mac)
- Mobile browsers (responsive design)

### Console Debugging
Open browser DevTools (F12) and check:
```javascript
// In console, verify functions are loaded:
typeof calculateStandard  // Should return "function"
typeof calculateAdvanced  // Should return "function"
typeof addStint          // Should return "function"

// Test calculation directly:
// Set some values first via UI, then:
calculateStandard();  // Should update results
```

## Contact & Resources

- Original Calculator: https://pitskill.io/fuel-calculator
- Extracted Files: `C:\dev\wp\fuel-calculator\`
- Key Functions: `calculateStandard()`, `calculateAdvanced()`, `addStint()`

---

**Note**: This is a clean-room implementation based on observed functionality. No copyrighted code was directly copied. The logic has been recreated based on the calculator's behaviour and standard racing fuel calculation formulas.