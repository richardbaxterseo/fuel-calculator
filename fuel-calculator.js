// Fuel Calculator JavaScript

// State management
let currentTab = 'standard';
let stintCount = 0;

// Standard Calculator Elements
const raceHours = document.getElementById('raceHours');
const raceMinutes = document.getElementById('raceMinutes');
const raceLaps = document.getElementById('raceLaps');
const lapMinutes = document.getElementById('lapMinutes');
const lapSeconds = document.getElementById('lapSeconds');
const totalLaps = document.getElementById('totalLaps');
const fuelPerLap = document.getElementById('fuelPerLap');
const extraLaps = document.getElementById('extraLaps');
const useLaps = document.getElementById('useLaps');

// Result Elements
const resultFuelPerLap = document.getElementById('resultFuelPerLap');
const resultFuelNeeded = document.getElementById('resultFuelNeeded');
const resultSafeFuel = document.getElementById('resultSafeFuel');
const extraLapsDisplay = document.getElementById('extraLapsDisplay');

// Advanced Calculator Elements
const tankCapacity = document.getElementById('tankCapacity');
const advFuelPerLap = document.getElementById('advFuelPerLap');
const stintsContainer = document.getElementById('stints-container');
const advTotalLaps = document.getElementById('advTotalLaps');
const advTotalFuel = document.getElementById('advTotalFuel');
const advNumStints = document.getElementById('advNumStints');

// Event Listeners
raceHours.addEventListener('input', calculateStandard);
raceMinutes.addEventListener('input', calculateStandard);
raceLaps.addEventListener('input', calculateStandard);
lapMinutes.addEventListener('input', calculateStandard);
lapSeconds.addEventListener('input', calculateStandard);
fuelPerLap.addEventListener('input', calculateStandard);
extraLaps.addEventListener('input', updateExtraLapsDisplay);

tankCapacity.addEventListener('input', calculateAdvanced);
advFuelPerLap.addEventListener('input', calculateAdvanced);

// Functions
function switchTab(tab) {
    currentTab = tab;
    
    // Update tab buttons
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    document.querySelector(`.tab:nth-child(${tab === 'standard' ? 1 : 2})`).classList.add('active');
    
    // Update tab content
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    document.getElementById(`${tab}-tab`).classList.add('active');
    
    // Add initial stint for advanced tab
    if (tab === 'advanced' && stintCount === 0) {
        addStint();
    }
}

function toggleRaceMode() {
    const usingLaps = useLaps.checked;
    
    // Toggle enabled/disabled states
    raceHours.disabled = usingLaps;
    raceMinutes.disabled = usingLaps;
    raceLaps.disabled = !usingLaps;
    
    // Reset values
    if (usingLaps) {
        raceHours.value = 0;
        raceMinutes.value = 0;
    } else {
        raceLaps.value = 0;
    }
    
    calculateStandard();
}

function calculateStandard() {
    const lapTimeSeconds = parseInt(lapMinutes.value || 0) * 60 + parseInt(lapSeconds.value || 0);
    
    if (lapTimeSeconds === 0) {
        totalLaps.value = 0;
        updateResults(0, 0, 0);
        return;
    }
    
    let estimatedLaps = 0;
    
    if (useLaps.checked) {
        // Using lap count directly
        estimatedLaps = parseInt(raceLaps.value || 0);
    } else {
        // Calculate from time
        const raceTimeSeconds = parseInt(raceHours.value || 0) * 3600 + parseInt(raceMinutes.value || 0) * 60;
        estimatedLaps = Math.ceil(raceTimeSeconds / lapTimeSeconds);
    }
    
    totalLaps.value = estimatedLaps;
    
    const fuelPerLapValue = parseFloat(fuelPerLap.value || 0);
    const extraLapsValue = parseInt(extraLaps.value || 0);
    
    const totalFuel = estimatedLaps * fuelPerLapValue;
    const safeFuel = (estimatedLaps + extraLapsValue) * fuelPerLapValue;
    
    updateResults(fuelPerLapValue, totalFuel, safeFuel);
}

function updateResults(fuelPerLapValue, totalFuel, safeFuel) {
    resultFuelPerLap.textContent = fuelPerLapValue.toFixed(2);
    resultFuelNeeded.textContent = `${totalFuel.toFixed(2)} Litres`;
    resultSafeFuel.textContent = `${safeFuel.toFixed(2)} Litres`;
}

function updateExtraLapsDisplay() {
    extraLapsDisplay.textContent = extraLaps.value;
    calculateStandard();
}

// Advanced Calculator Functions
function addStint() {
    stintCount++;
    
    const stintDiv = document.createElement('div');
    stintDiv.className = 'stint-container';
    stintDiv.id = `stint-${stintCount}`;
    
    stintDiv.innerHTML = `
        <div class="stint-header">
            <h4>Stint ${stintCount}</h4>
            ${stintCount > 1 ? `<button class="secondary" onclick="removeStint(${stintCount})">Remove</button>` : ''}
        </div>
        <div class="input-group">
            <div class="input-row">
                <div class="input-wrapper">
                    <label>Stint Length (Laps)</label>
                    <input type="number" id="stint-laps-${stintCount}" placeholder="0" min="0" value="0" onchange="calculateAdvanced()">
                    <span class="unit">Laps</span>
                </div>
                <div class="input-wrapper">
                    <label>Fuel Load</label>
                    <input type="number" id="stint-fuel-${stintCount}" placeholder="0" min="0" step="0.1" value="0" onchange="calculateAdvanced()">
                    <span class="unit">Litres</span>
                </div>
            </div>
        </div>
        <div class="info-text">
            <span id="stint-info-${stintCount}">Maximum laps: 0</span>
        </div>
    `;
    
    stintsContainer.appendChild(stintDiv);
    calculateAdvanced();
}

function removeStint(stintId) {
    const stintElement = document.getElementById(`stint-${stintId}`);
    if (stintElement) {
        stintElement.remove();
        calculateAdvanced();
    }
}

function calculateAdvanced() {
    const tankCapacityValue = parseFloat(tankCapacity.value || 0);
    const fuelPerLapValue = parseFloat(advFuelPerLap.value || 0);
    
    let totalLapsCount = 0;
    let totalFuelCount = 0;
    let stintsCount = 0;
    
    // Calculate for each stint
    const stints = stintsContainer.querySelectorAll('.stint-container');
    stints.forEach((stint, index) => {
        const stintId = index + 1;
        const stintLapsInput = stint.querySelector(`#stint-laps-${stint.id.split('-')[1]}`);
        const stintFuelInput = stint.querySelector(`#stint-fuel-${stint.id.split('-')[1]}`);
        const stintInfo = stint.querySelector(`#stint-info-${stint.id.split('-')[1]}`);
        
        if (stintLapsInput && stintFuelInput && stintInfo) {
            const stintLaps = parseInt(stintLapsInput.value || 0);
            const stintFuel = parseFloat(stintFuelInput.value || 0);
            
            // Calculate maximum laps for this stint
            let maxLaps = 0;
            if (fuelPerLapValue > 0) {
                const effectiveFuel = Math.min(stintFuel, tankCapacityValue);
                maxLaps = Math.floor(effectiveFuel / fuelPerLapValue);
            }
            
            stintInfo.textContent = `Maximum laps: ${maxLaps} (Tank limit: ${tankCapacityValue}L)`;
            
            if (stintLaps > 0) {
                totalLapsCount += stintLaps;
                totalFuelCount += stintLaps * fuelPerLapValue;
                stintsCount++;
            }
        }
    });
    
    // Update results
    advTotalLaps.textContent = `${totalLapsCount} Laps`;
    advTotalFuel.textContent = `${totalFuelCount.toFixed(2)} Litres`;
    advNumStints.textContent = stintsCount;
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    calculateStandard();
    updateExtraLapsDisplay();
});