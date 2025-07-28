# Developer Prompt: Convert FOV Calculator to Fuel Calculator Plugin

## Project Overview
Convert the existing FOV Calculator WordPress plugin into a Fuel Calculator plugin for sim racing. Both calculators share the same fundamental architecture: input fields, real-time calculations, and result display. The styling and structure can remain largely the same.

## Source and Destination
- **Source Plugin**: `C:\dev\wp\fov-calculator\` (copy this as template)
- **Destination**: `C:\dev\wp\fuel-calculator\` (create new plugin here)
- **JavaScript Logic**: Already created at `C:\dev\wp\fuel-calculator\fuel-calculator.js`

## Step-by-Step Conversion Instructions

### 1. Initial Setup
```bash
# Copy the FOV calculator plugin structure
cp -r "C:\dev\wp\fov-calculator" "C:\dev\wp\fuel-calculator"
cd "C:\dev\wp\fuel-calculator"

# Remove FOV-specific files but keep structure
# Keep: Plugin structure, class files, assets folders
# Remove: FOV calculation logic, will be replaced
```

### 2. File Renaming Requirements
Rename these files systematically:
- `fov-calculator.php` → `fuel-calculator.php`
- `includes/class-fov-calculator.php` → `includes/class-fuel-calculator.php`
- `assets/js/fov-calculator.js` → Replace with existing `fuel-calculator.js`
- `assets/css/fov-calculator.css` → `assets/css/fuel-calculator.css`
- Update all file references in the code

### 3. Plugin Header Updates
In `fuel-calculator.php`, update:
```php
/**
 * Plugin Name: Fuel Calculator for Sim Racing
 * Plugin URI: https://simracingcockpit.gg/fuel-calculator
 * Description: Calculate optimal fuel loads for sim racing. Supports both time and lap-based races with multi-stint planning.
 * Version: 1.0.0
 * Author: Richard Baxter
 * Author URI: https://simracingcockpit.gg
 * License: GPL v2 or later
 * Text Domain: fuel-calculator
 * Domain Path: /languages
 */
```

### 4. Constants and Namespacing
Replace all constants and class names:
- `FOV_CALC_*` → `FUEL_CALC_*`
- `class FOV_Calculator` → `class Fuel_Calculator`
- `fov_calculator_*` functions → `fuel_calculator_*` functions
- `fov-calculator` text domain → `fuel-calculator`

### 5. Shortcode Updates
The plugin uses shortcodes. Update:
- `[fov_calculator]` → `[fuel_calculator]`
- Keep the same rendering structure but update the HTML

### 6. HTML Structure for Calculator
Replace the FOV calculator HTML with this structure (based on fuel-calculator.html):

```html
<div id="fuel-calculator-wrapper">
    <!-- Tab Navigation -->
    <div class="calculator-tabs">
        <button class="tab active" onclick="switchTab('standard')">Standard Calculator</button>
        <button class="tab" onclick="switchTab('advanced')">Advanced Calculator</button>
    </div>

    <!-- Standard Calculator Tab -->
    <div id="standard-tab" class="tab-content active">
        <!-- Copy structure from fuel-calculator.html -->
        <!-- Includes: Race Length, Lap Time, Fuel Per Lap inputs -->
        <!-- Results section with live updates -->
    </div>

    <!-- Advanced Calculator Tab -->
    <div id="advanced-tab" class="tab-content">
        <!-- Copy structure from fuel-calculator.html -->
        <!-- Includes: Tank Capacity, Fuel Per Lap, Dynamic Stints -->
    </div>
</div>
```

### 7. JavaScript Integration
The JavaScript logic already exists at `C:\dev\wp\fuel-calculator\fuel-calculator.js`:
- Copy this file to `assets/js/fuel-calculator.js`
- Ensure it's enqueued properly in the plugin class
- Key functions available:
  - `calculateStandard()` - Standard calculator logic
  - `calculateAdvanced()` - Multi-stint calculator
  - `addStint()` - Add new stint dynamically
  - `removeStint()` - Remove stint
  - `switchTab()` - Tab switching
  - `toggleRaceMode()` - Switch between time/lap modes

### 8. CSS Styling Updates
Keep the same professional styling from FOV calculator but update:
- Color scheme can remain the same (or adjust to preference)
- Update class names from `.fov-*` to `.fuel-*`
- Ensure responsive design is maintained
- Add styles for:
  - Tab navigation
  - Stint containers
  - Results display
  - Toggle switches

### 9. Key Features to Implement

#### Standard Calculator:
- **Inputs**: Race hours/minutes OR laps, lap time, fuel per lap
- **Toggle**: "Use Laps Instead of Time" switch
- **Outputs**: Total laps, fuel needed, safe fuel (with extra laps)
- **Real-time**: Updates on any input change

#### Advanced Calculator:
- **Inputs**: Tank capacity, fuel per lap
- **Dynamic Stints**: Add/remove stint blocks
- **Per Stint**: Laps and fuel load inputs
- **Outputs**: Total laps, total fuel, number of stints
- **Validation**: Show max possible laps per stint

### 10. Enqueue Scripts Properly
In the main plugin class:
```php
public function enqueue_scripts() {
    if (!is_singular() || !has_shortcode(get_post()->post_content, 'fuel_calculator')) {
        return;
    }
    
    wp_enqueue_script(
        'fuel-calculator',
        FUEL_CALC_PLUGIN_URL . 'assets/js/fuel-calculator.js',
        array(),
        FUEL_CALC_VERSION,
        true
    );
    
    wp_enqueue_style(
        'fuel-calculator',
        FUEL_CALC_PLUGIN_URL . 'assets/css/fuel-calculator.css',
        array(),
        FUEL_CALC_VERSION
    );
}
```

### 11. Calculation Logic Verification
The JavaScript already implements:
- ✅ Time-based race calculations (hours + minutes → laps)
- ✅ Lap-based race calculations (direct lap count)
- ✅ Fuel calculations with safety margin (extra laps)
- ✅ Multi-stint planning with tank capacity limits
- ✅ Real-time updates on input changes
- ✅ Proper rounding (Math.ceil for laps)

### 12. Testing Checklist
After conversion, test:
- [ ] Shortcode `[fuel_calculator]` renders properly
- [ ] Tab switching works
- [ ] Standard calculator: 90-minute race, 1:45 laps, 2.8L/lap = 52 laps, 145.6L
- [ ] Lap mode toggle switches input fields correctly
- [ ] Advanced calculator: Multiple stints can be added/removed
- [ ] Tank capacity limits are enforced
- [ ] All calculations update in real-time
- [ ] Responsive design works on mobile

### 13. File Structure After Conversion
```
fuel-calculator/
├── fuel-calculator.php          (main plugin file)
├── readme.txt                   (WordPress.org readme)
├── README.md                    (GitHub readme)
├── CHANGELOG.md                 (version history)
├── includes/
│   └── class-fuel-calculator.php (main plugin class)
├── assets/
│   ├── js/
│   │   └── fuel-calculator.js   (calculation logic)
│   └── css/
│       └── fuel-calculator.css  (styling)
└── languages/                   (translations)
```

### 14. Important Notes
- The fuel calculator has TWO modes (Standard and Advanced) unlike FOV
- Advanced mode has dynamic UI elements (add/remove stints)
- Maintain the same code quality and structure as FOV calculator
- Keep responsive design principles
- Use the same enqueueing pattern to load assets only where needed
- The JavaScript is already tested and working correctly

### 15. Quick Wins
Since both calculators are fundamentally similar:
1. The plugin activation/deactivation hooks can stay the same
2. The shortcode rendering pattern remains identical
3. The asset loading logic doesn't change
4. The basic CSS structure can be reused
5. The responsive design approach carries over

## Final Steps
1. Update version to 1.0.0 for initial release
2. Test the complete plugin in a WordPress environment
3. Verify all calculations match the test cases
4. Update documentation (README.md, readme.txt)
5. Add any additional features or improvements identified during development

This is a straightforward conversion since both calculators share the same fundamental architecture. The main work is replacing the calculation logic and updating the UI to handle the two-tab structure and dynamic stint management.