// Fuel Calculator JavaScript

// Wait for DOM to be ready
document.addEventListener('DOMContentLoaded', function() {
    // Check if calculator exists on page
    const calculatorWrapper = document.getElementById('fuel-calculator-wrapper');
    if (!calculatorWrapper) {
        return;
    }

    // Initialize the calculator
    initializeFuelCalculator();
});

function initializeFuelCalculator() {
    // State management
    let currentTab = 'standard';
    let stintCount = 0;

    // Initial calculations
    calculateStandard();
    
    // Make functions global for onclick handlers
    window.switchTab = switchTab;
    window.toggleRaceMode = toggleRaceMode;
    window.calculateStandard = calculateStandard;
    window.calculateAdvanced = calculateAdvanced;
    window.addStint = addStint;
    window.removeStint = removeStint;

    function switchTab(tab) {
        currentTab = tab;
        
        // Update tab buttons
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        event.target.classList.add('active');
        
        // Update tab content
        document.getElementById('standard-tab').style.display = tab === 'standard' ? 'block' : 'none';
        document.getElementById('advanced-tab').style.display = tab === 'advanced' ? 'block' : 'none';
        
        // Add initial stint for advanced tab
        if (tab === 'advanced' && stintCount === 0) {
            addStint();
        }
    }

    function toggleRaceMode() {
        const toggle = document.getElementById('race-mode-toggle');
        const usingLaps = toggle.checked;
        
        // Toggle visibility
        document.getElementById('time-inputs').style.display = usingLaps ? 'none' : 'block';
        document.getElementById('lap-inputs').style.display = usingLaps ? 'block' : 'none';
        
        calculateStandard();
    }

    function calculateStandard() {
        const toggle = document.getElementById('race-mode-toggle');
        const usingLaps = toggle.checked;
        
        // Get input values
        const lapMinutes = parseInt(document.getElementById('lap-minutes').value || 0);
        const lapSeconds = parseInt(document.getElementById('lap-seconds').value || 0);
        const lapTimeSeconds = lapMinutes * 60 + lapSeconds;
        
        if (lapTimeSeconds === 0) {
            updateStandardResults(0, 0, 0);
            return;
        }
        
        let estimatedLaps = 0;
        
        if (usingLaps) {
            // Using lap count directly
            estimatedLaps = parseInt(document.getElementById('race-laps').value || 0);
        } else {
            // Calculate from time
            const raceHours = parseInt(document.getElementById('race-hours').value || 0);
            const raceMinutes = parseInt(document.getElementById('race-minutes').value || 0);
            const raceTimeSeconds = raceHours * 3600 + raceMinutes * 60;
            estimatedLaps = Math.ceil(raceTimeSeconds / lapTimeSeconds);
        }
        
        const fuelPerLapValue = parseFloat(document.getElementById('fuel-per-lap').value || 0);
        const extraLaps = 2; // Fixed at 2 extra laps for safety
        
        const totalFuel = estimatedLaps * fuelPerLapValue;
        const safeFuel = (estimatedLaps + extraLaps) * fuelPerLapValue;
        
        updateStandardResults(estimatedLaps, totalFuel, safeFuel);
    }

    function updateStandardResults(laps, totalFuel, safeFuel) {
        document.getElementById('standard-total-laps').textContent = laps + ' laps';
        document.getElementById('standard-fuel-needed').textContent = totalFuel.toFixed(1) + ' L';
        document.getElementById('standard-safe-fuel').textContent = safeFuel.toFixed(1) + ' L';
    }

    // Advanced Calculator Functions
    function addStint() {
        stintCount++;
        
        const stintDiv = document.createElement('div');
        stintDiv.className = 'stint-container';
        stintDiv.id = 'stint-' + stintCount;
        
        stintDiv.innerHTML = `
            <div class="stint-header">
                <h4>Stint ${stintCount}</h4>
                ${stintCount > 1 ? `<button class="remove-stint-btn" onclick="removeStint(${stintCount})">Remove</button>` : ''}
            </div>
            <div class="stint-inputs">
                <div class="input-group">
                    <label>Stint Length</label>
                    <div class="input-wrapper">
                        <input type="number" id="stint-laps-${stintCount}" min="0" value="0" onchange="calculateAdvanced()">
                        <span class="unit">laps</span>
                    </div>
                </div>
                <div class="input-group">
                    <label>Fuel Load</label>
                    <div class="input-wrapper">
                        <input type="number" id="stint-fuel-${stintCount}" min="0" step="0.1" value="0" onchange="calculateAdvanced()">
                        <span class="unit">L</span>
                    </div>
                </div>
            </div>
            <div class="stint-info">
                <span id="stint-info-${stintCount}">Maximum laps: 0</span>
            </div>
        `;
        
        document.getElementById('stints-container').appendChild(stintDiv);
        calculateAdvanced();
    }

    function removeStint(stintId) {
        const stintElement = document.getElementById('stint-' + stintId);
        if (stintElement) {
            stintElement.remove();
            calculateAdvanced();
        }
    }

    function calculateAdvanced() {
        const tankCapacityValue = parseFloat(document.getElementById('tank-capacity').value || 0);
        const fuelPerLapValue = parseFloat(document.getElementById('adv-fuel-per-lap').value || 0);
        
        let totalLapsCount = 0;
        let totalFuelCount = 0;
        let stintsCount = 0;
        
        // Calculate for each stint
        const stints = document.querySelectorAll('.stint-container');
        stints.forEach(function(stint) {
            const stintId = stint.id.split('-')[1];
            const stintLapsInput = stint.querySelector('#stint-laps-' + stintId);
            const stintFuelInput = stint.querySelector('#stint-fuel-' + stintId);
            const stintInfo = stint.querySelector('#stint-info-' + stintId);
            
            if (stintLapsInput && stintFuelInput && stintInfo) {
                const stintLaps = parseInt(stintLapsInput.value || 0);
                const stintFuel = parseFloat(stintFuelInput.value || 0);
                
                // Calculate maximum laps for this stint
                let maxLaps = 0;
                if (fuelPerLapValue > 0) {
                    const effectiveFuel = Math.min(stintFuel, tankCapacityValue);
                    maxLaps = Math.floor(effectiveFuel / fuelPerLapValue);
                }
                
                stintInfo.textContent = 'Maximum laps: ' + maxLaps + ' (Tank limit: ' + tankCapacityValue + 'L)';
                
                if (stintLaps > 0) {
                    totalLapsCount += stintLaps;
                    totalFuelCount += stintLaps * fuelPerLapValue;
                    stintsCount++;
                }
            }
        });
        
        // Update results
        document.getElementById('advanced-total-laps').textContent = totalLapsCount + ' laps';
        document.getElementById('advanced-total-fuel').textContent = totalFuelCount.toFixed(1) + ' L';
        document.getElementById('advanced-stint-count').textContent = stintsCount;
    }
}