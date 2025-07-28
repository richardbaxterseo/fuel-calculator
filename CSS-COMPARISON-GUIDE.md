# CSS Comparison Quick Reference

## Current Fuel Calculator vs Target FOV Calculator Styles

### Main Container
```css
/* CURRENT (Fuel Calculator) */
#fuel-calculator-wrapper {
    background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
    /* Orange pattern overlay */
    background-image: repeating-linear-gradient(45deg, transparent, transparent 35px, 
        rgba(255,75,43,.02) 35px, rgba(255,75,43,.02) 70px);
}

/* TARGET (FOV Calculator Style) */
#fuel-calculator-wrapper {
    background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
    /* Green pattern overlay */
    background-image: repeating-linear-gradient(45deg, transparent, transparent 35px, 
        rgba(76,175,80,.02) 35px, rgba(76,175,80,.02) 70px);
}
```

### Primary Button/Active States
```css
/* CURRENT (Orange) */
.fuel-primary-btn {
    background: #ff4b2b;
    color: white;
}
.fuel-primary-btn:hover {
    background: #ff6347;
}

/* TARGET (Green) */
.fuel-primary-btn {
    background: #4CAF50;
    color: white;
}
.fuel-primary-btn:hover {
    background: #45a049;
}
```

### Result Values
```css
/* CURRENT */
.result-value {
    color: #ff4b2b;
    font-size: 28px;
}

/* TARGET */
.result-value {
    color: #4CAF50;
    font-size: 20px;
    font-weight: 600;
}
```

### Form Inputs
```css
/* CURRENT */
input[type="number"] {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: #fff;
    height: 40px;
}

/* TARGET (FOV Style) */
input[type="number"] {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: #fff;
    height: 45px;
    padding: 0 15px;
    border-radius: 8px;
    transition: all 0.3s ease;
}
input[type="number"]:focus {
    border-color: #4CAF50;
    outline: none;
    background: rgba(255, 255, 255, 0.15);
}
```

### Tab Navigation (Unique to Fuel)
```css
/* CURRENT */
.calculator-tabs .tab.active {
    background: linear-gradient(135deg, #ff4b2b 0%, #ff6347 100%);
    color: #fff;
}

/* TARGET (Keep tabs but green) */
.calculator-tabs .tab.active {
    background: #4CAF50;
    color: #fff;
    position: relative;
}
.calculator-tabs .tab.active::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: #45a049;
}
```

### Quick Conversion Table

| Element | Current (Orange) | Target (Green) |
|---------|-----------------|----------------|
| Primary Colour | #ff4b2b | #4CAF50 |
| Hover Colour | #ff6347 | #45a049 |
| Dark Variant | #cc3a22 | #388E3C |
| Light Tint | rgba(255,75,43,0.1) | rgba(76,175,80,0.1) |
| Pattern Overlay | rgba(255,75,43,0.02) | rgba(76,175,80,0.02) |

## Testing URLs
- **FOV Calculator Demo**: [View FOV styles in action]
- **Current Fuel Calculator**: [Your test instance]

## Remember
The goal is not to make them identical, but to make them feel like family. Keep the functional differences (tabs, stints, toggles) but unify the visual language.
