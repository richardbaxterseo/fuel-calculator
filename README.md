# Sim Racing Fuel Calculator

A recreation of the Pitskill.io fuel calculator for sim racing. This tool helps racers calculate fuel requirements for races based on race length, lap times, and fuel consumption.

## Features

### Standard Calculator
- Calculate fuel based on race duration (hours/minutes) or lap count
- Input your average lap time
- Set fuel consumption per lap
- Add safety margin with extra laps
- Get instant calculations for:
  - Total estimated laps
  - Total fuel needed
  - Safe fuel amount (with extra laps buffer)

### Advanced Calculator
- Plan multiple stints with different fuel loads
- Account for fuel tank capacity limits
- Calculate maximum possible laps per stint
- Track total fuel requirements across all stints

## How to Use

### Standard Mode
1. Choose between time-based or lap-based calculation using the toggle
2. Enter your race length (either time or laps)
3. Input your average lap time
4. Set your fuel consumption per lap
5. Adjust extra laps for safety margin
6. View calculated results instantly

### Advanced Mode
1. Set your fuel tank capacity
2. Enter fuel consumption per lap
3. Add stints as needed
4. For each stint, specify:
   - Number of laps planned
   - Fuel load for that stint
5. View maximum possible laps based on fuel load
6. See total race statistics

## Technical Details

The calculator is built with:
- Pure HTML/CSS/JavaScript (no frameworks)
- Responsive design that works on mobile and desktop
- Dark theme matching the original Pitskill.io aesthetic
- Real-time calculations as you type

## Files

- `fuel-calculator.html` - Main HTML structure
- `fuel-calculator.js` - Calculator logic and interactivity
- `README.md` - This documentation file

## Usage

Simply open `fuel-calculator.html` in any modern web browser. No server or installation required.

## Credits

This is a recreation of the fuel calculator found on [Pitskill.io](https://pitskill.io/fuel-calculator), built for educational and demonstration purposes.