# Fuel Calculator - Frontend Developer Handover

## Overview
You'll be working on the Fuel Calculator plugin's CSS to align it with our FOV Calculator's design system for brand consistency. Both calculators should feel like part of the same product family while maintaining their unique functional requirements.

## Current State
- **Fuel Calculator**: Dark theme with orange accent (#ff4b2b)
- **FOV Calculator**: Dark theme with green accent (needs matching)
- Both use similar gradient backgrounds but different implementations

## File Locations

### Primary CSS File to Edit:
```
fuel-calculator/assets/css/fuel-calculator.css
```

### Reference CSS File (FOV Calculator):
```
fov-calculator/assets/css/fov-calculator.css
```

## Design System to Implement

### Colour Palette (from FOV Calculator)
```css
/* Primary Colours */
--primary-green: #4CAF50;
--primary-hover: #45a049;
--primary-dark: #388E3C;

/* Background Colours */
--bg-primary: #1a1a1a;
--bg-secondary: #2d2d2d;
--bg-overlay: rgba(0, 0, 0, 0.3);

/* Text Colours */
--text-primary: #ffffff;
--text-secondary: rgba(255, 255, 255, 0.7);
--text-muted: rgba(255, 255, 255, 0.5);

/* Status Colours */
--success: #4CAF50;
--warning: #ff9800;
--error: #f44336;
```

### Key Design Elements to Match

1. **Container Styling**
   - Border radius: 16px
   - Box shadow: 0 15px 40px rgba(0, 0, 0, 0.3)
   - Gradient background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%)

2. **Typography**
   - Font family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif
   - Heading sizes: h2 (24px), h3 (18px)
   - Body text: 16px
   - Small text: 14px

3. **Form Elements**
   - Input height: 45px
   - Border radius: 8px
   - Background: rgba(255, 255, 255, 0.1)
   - Border: 1px solid rgba(255, 255, 255, 0.2)
   - Focus state: border-color changes to primary colour

4. **Buttons**
   - Primary button: Background matches primary colour
   - Height: 45px
   - Border radius: 8px
   - Hover state: Slightly darker shade
   - Transition: all 0.3s ease

## Specific Changes Needed

### 1. Replace Orange Accent with Green
Change all instances of:
```css
/* Current orange */
#ff4b2b → #4CAF50 (primary green)
#ff6347 → #45a049 (hover green)
rgba(255,75,43,0.X) → rgba(76,175,80,0.X)
```

### 2. Update Tab Navigation
Current fuel calculator has tabs, FOV doesn't. Keep tab functionality but style to match:
```css
.calculator-tabs .tab {
    /* Match FOV's button styling */
    background: transparent;
    color: rgba(255, 255, 255, 0.7);
    transition: all 0.3s ease;
}

.calculator-tabs .tab.active {
    background: #4CAF50;
    color: #ffffff;
}
```

### 3. Result Display Styling
Align with FOV's result presentation:
```css
.result-row {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
    padding: 12px 15px;
    margin-bottom: 10px;
}

.result-label {
    color: rgba(255, 255, 255, 0.7);
    font-size: 14px;
}

.result-value {
    color: #4CAF50;
    font-size: 20px;
    font-weight: 600;
}
```

### 4. Mobile Responsive Breakpoints
Match FOV Calculator's approach:
```css
@media (max-width: 768px) {
    /* Tablet adjustments */
}

@media (max-width: 480px) {
    /* Mobile adjustments */
    #fuel-calculator-wrapper {
        border-radius: 0;
        margin: 0;
    }
}
```

## Unique Fuel Calculator Elements to Preserve

1. **Tab System** - Keep the Standard/Advanced tabs but style consistently
2. **Stint Management** - The advanced calculator's dynamic stint rows
3. **Toggle Switch** - Time/Lap mode toggle in standard calculator
4. **Safety Fuel Highlight** - Keep the emphasis on safety fuel calculations

## Testing Checklist

- [ ] Colours match FOV Calculator's green theme
- [ ] Form inputs have consistent styling
- [ ] Hover states work on all interactive elements
- [ ] Results display clearly with proper hierarchy
- [ ] Mobile responsive design matches FOV approach
- [ ] Tab navigation feels smooth and obvious
- [ ] Stint add/remove buttons are clearly styled
- [ ] All text is readable with proper contrast
- [ ] Loading states (if any) match the design system

## Development Workflow

1. **Setup**: Install plugin in WordPress test environment
2. **Hot Reload**: Use browser DevTools for live CSS editing
3. **Test Page**: Create a test page with `[fuel_calculator]` shortcode
4. **Cross-Browser**: Test in Chrome, Firefox, Safari, Edge
5. **Mobile**: Test on actual devices, not just responsive mode

## CSS Architecture Notes

- Use CSS custom properties (variables) for maintainability
- Keep specificity low - avoid !important where possible
- Comment major sections for clarity
- Maintain alphabetical property ordering within rules
- Group related styles together

## Accessibility Considerations

- Maintain WCAG AA contrast ratios (4.5:1 for normal text)
- Ensure focus states are visible
- Don't rely on colour alone for information
- Test with keyboard navigation

## Final Deliverable

The fuel calculator should feel like a natural sibling to the FOV calculator - same family, same quality, just different tools for different jobs. Users should immediately recognise them as part of the same suite.

## Questions?
If you need clarification on any design decisions or encounter edge cases not covered here, please ask. The goal is consistency without compromising functionality.
