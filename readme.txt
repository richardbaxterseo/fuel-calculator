=== Fuel Calculator for Sim Racing ===
Contributors: richardbaxter
Tags: sim racing, fuel calculator, racing, calculator, fuel management
Requires at least: 5.0
Tested up to: 6.4
Requires PHP: 7.2
Stable tag: 1.1.0
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Calculate optimal fuel loads for sim racing with support for both time and lap-based races, including multi-stint planning.

== Description ==

The Fuel Calculator for Sim Racing is a comprehensive tool designed to help sim racers calculate the exact amount of fuel needed for their races. Whether you're running a sprint race or planning a multi-stint endurance event, this calculator has you covered.

**Features:**

* **Standard Calculator** - Quick calculations for single-stint races
* **Advanced Calculator** - Multi-stint planning with tank capacity limits
* **Flexible Input Modes** - Calculate by race time or number of laps
* **Safety Margins** - Automatic calculation with extra laps for safety
* **Real-time Updates** - See results instantly as you type
* **Mobile Responsive** - Works perfectly on all devices
* **Clean, Modern Design** - Professional interface that looks great on any site

**Standard Calculator Features:**
- Input race length by time (hours/minutes) or laps
- Enter average lap time and fuel consumption
- Automatic calculation of total fuel needed
- Safety fuel calculation (includes 2 extra laps)

**Advanced Calculator Features:**
- Set your car's tank capacity
- Plan multiple stints with different fuel loads
- See maximum possible laps per stint
- Track total fuel usage across all stints
- Dynamic stint management (add/remove as needed)

**Perfect for:**
- iRacing endurance races
- ACC (Assetto Corsa Competizione) championships
- rFactor 2 online events
- Any sim racing platform with fuel management

== Installation ==

1. Upload the plugin files to the `/wp-content/plugins/fuel-calculator` directory, or install the plugin through the WordPress plugins screen directly.
2. Activate the plugin through the 'Plugins' screen in WordPress
3. Use the shortcode `[fuel_calculator]` in any post or page where you want the calculator to appear

== Frequently Asked Questions ==

= How do I add the calculator to my page? =

Simply add the shortcode `[fuel_calculator]` to any post or page. The calculator will automatically appear with both standard and advanced modes available.

= Can I customize the appearance? =

Yes! The plugin includes CSS classes that can be targeted for custom styling. You can also use the theme parameter: `[fuel_calculator theme="dark"]`

= Does it work with all sim racing games? =

Yes! The calculator uses universal measurements (litres and laps) that work with any racing simulator that has fuel consumption.

= Is the calculator mobile-friendly? =

Absolutely! The calculator is fully responsive and works perfectly on smartphones, tablets, and desktop computers.

= How accurate are the calculations? =

The calculator uses precise mathematical formulas and always rounds up to ensure you never run out of fuel. The safety margin adds 2 extra laps worth of fuel for additional security.

== Screenshots ==

1. Standard calculator interface showing time-based calculation
2. Standard calculator with lap-based mode activated
3. Advanced multi-stint calculator
4. Mobile responsive view
5. Results display with safety fuel calculation

== Changelog ==

= 1.1.0 =
* Style: Complete CSS redesign to align with FOV Calculator green theme
* Style: Replaced orange accent (#ff4b2b) with green (#4CAF50)
* Enhancement: Introduced CSS custom properties for better maintainability
* Enhancement: Improved accessibility with proper focus states
* Enhancement: Better mobile responsive behaviour
* Enhancement: Added support for light/dark themes

= 1.0.0 =
* Initial release
* Standard calculator with time/lap modes
* Advanced multi-stint calculator
* Real-time calculations
* Mobile responsive design
* Safety fuel calculations

== Upgrade Notice ==

= 1.0.0 =
Initial release of the Fuel Calculator for Sim Racing.