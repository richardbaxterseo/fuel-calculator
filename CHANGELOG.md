# Changelog

All notable changes to the Fuel Calculator for Sim Racing plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2025-07-28

### Changed
- Calculator now uses full width of content area (removed 800px constraint)
- Input rows now use CSS Grid with auto-fit for better responsiveness
- Stint inputs adapt from 2 columns to more on wider screens
- Increased desktop padding to 60px for better proportions

### Added
- Optional .fuel-calculator-contained class for 1200px max-width centered layout
- Results section can display in multiple columns on wide screens
- Better responsive grid layouts throughout

### Enhanced
- Better space utilisation on all screen sizes
- Improved visual balance for full-width layouts
- More flexible grid systems for inputs

## [1.1.0] - 2025-07-28

### Changed
- Complete CSS redesign to align with FOV Calculator green theme
- Replaced orange accent colour (#ff4b2b) with green (#4CAF50) throughout
- Updated all interactive elements to use consistent green colour scheme

### Added
- CSS custom properties (variables) for better maintainability
- Improved focus states for better accessibility
- Enhanced mobile responsive behaviour with better breakpoints
- Light/dark theme support with proper variable usage
- Print styles for better output when printing calculations

### Enhanced
- Tab navigation styling with smoother transitions
- Input field styling to match FOV Calculator standards
- Button hover states with transform animations
- Result display with better visual hierarchy
- Stint management interface with improved contrast

## [1.0.0] - 2025-07-28

### Added
- Initial release of Fuel Calculator for Sim Racing
- Standard calculator with time/lap modes
- Advanced multi-stint calculator
- Real-time calculations
- Mobile responsive design
- Safety fuel calculations with 2 lap buffer
- Support for both sprint races and endurance events
- Toggle between time-based and lap-based calculations
- Dynamic stint management for endurance races
- Clear visual feedback for results
- WordPress shortcode [fuel_calculator]