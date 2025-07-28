<?php
/**
 * Main Fuel Calculator Plugin Class
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class Fuel_Calculator {
    
    /**
     * Initialize the plugin
     */
    public function init() {
        // Register shortcode
        add_shortcode('fuel_calculator', array($this, 'render_calculator'));
        
        // Register scripts and styles
        add_action('wp_enqueue_scripts', array($this, 'enqueue_assets'));
    }
    
    /**
     * Enqueue plugin assets
     */
    public function enqueue_assets() {
        // Only load on pages with the shortcode
        global $post;
        if (is_a($post, 'WP_Post') && has_shortcode($post->post_content, 'fuel_calculator')) {
            wp_enqueue_style(
                'fuel-calculator-style',
                FUEL_CALC_PLUGIN_URL . 'assets/css/fuel-calculator.css',
                array(),
                FUEL_CALC_VERSION
            );
            
            wp_enqueue_script(
                'fuel-calculator-script',
                FUEL_CALC_PLUGIN_URL . 'assets/js/fuel-calculator.js',
                array(), // No dependencies
                FUEL_CALC_VERSION,
                true
            );
        }
    }
    
    /**
     * Render the calculator shortcode
     */
    public function render_calculator($atts) {
        // Parse shortcode attributes
        $atts = shortcode_atts(array(
            'theme' => 'default'
        ), $atts);
        
        ob_start();
        ?>
        <div id="fuel-calculator-wrapper" class="fuel-theme-<?php echo esc_attr($atts['theme']); ?>">
            <!-- Tab Navigation -->
            <div class="calculator-tabs">
                <button class="tab active" onclick="switchTab('standard')"><?php _e('Standard Calculator', 'fuel-calculator'); ?></button>
                <button class="tab" onclick="switchTab('advanced')"><?php _e('Advanced Calculator', 'fuel-calculator'); ?></button>
            </div>

            <!-- Standard Calculator Tab -->
            <div id="standard-tab" class="tab-content active">
                <div class="calculator-card">
                    <h2><?php _e('Standard Fuel Calculator', 'fuel-calculator'); ?></h2>
                    
                    <!-- Race Mode Toggle -->
                    <div class="switch-container">
                        <span><?php _e('Use Laps Instead of Time', 'fuel-calculator'); ?></span>
                        <label class="switch">
                            <input type="checkbox" id="race-mode-toggle" onchange="toggleRaceMode()">
                            <span class="slider"></span>
                        </label>
                    </div>
                    
                    <!-- Time-based inputs -->
                    <div id="time-inputs">
                        <div class="input-group">
                            <label><?php _e('Race Length', 'fuel-calculator'); ?></label>
                            <div class="input-row">
                                <div class="input-wrapper">
                                    <input type="number" id="race-hours" min="0" max="24" value="1" onchange="calculateStandard()">
                                    <span class="unit"><?php _e('hrs', 'fuel-calculator'); ?></span>
                                </div>
                                <div class="input-wrapper">
                                    <input type="number" id="race-minutes" min="0" max="59" value="30" onchange="calculateStandard()">
                                    <span class="unit"><?php _e('min', 'fuel-calculator'); ?></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Lap-based input -->
                    <div id="lap-inputs" style="display: none;">
                        <div class="input-group">
                            <label><?php _e('Number of Laps', 'fuel-calculator'); ?></label>
                            <div class="input-wrapper">
                                <input type="number" id="race-laps" min="1" max="1000" value="50" onchange="calculateStandard()">
                                <span class="unit"><?php _e('laps', 'fuel-calculator'); ?></span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Common inputs -->
                    <div class="input-group">
                        <label><?php _e('Average Lap Time', 'fuel-calculator'); ?></label>
                        <div class="input-row">
                            <div class="input-wrapper">
                                <input type="number" id="lap-minutes" min="0" max="59" value="1" onchange="calculateStandard()">
                                <span class="unit"><?php _e('min', 'fuel-calculator'); ?></span>
                            </div>
                            <div class="input-wrapper">
                                <input type="number" id="lap-seconds" min="0" max="59" value="45" onchange="calculateStandard()">
                                <span class="unit"><?php _e('sec', 'fuel-calculator'); ?></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="input-group">
                        <label><?php _e('Fuel Per Lap', 'fuel-calculator'); ?></label>
                        <div class="input-wrapper">
                            <input type="number" id="fuel-per-lap" min="0.1" max="20" step="0.1" value="2.8" onchange="calculateStandard()">
                            <span class="unit"><?php _e('L', 'fuel-calculator'); ?></span>
                        </div>
                    </div>
                    
                    <!-- Results Section -->
                    <div class="results-section">
                        <h3><?php _e('Results', 'fuel-calculator'); ?></h3>
                        <div class="result-item">
                            <span class="result-label"><?php _e('Total Race Laps:', 'fuel-calculator'); ?></span>
                            <span class="result-value" id="standard-total-laps">-</span>
                        </div>
                        <div class="result-item">
                            <span class="result-label"><?php _e('Fuel Needed:', 'fuel-calculator'); ?></span>
                            <span class="result-value" id="standard-fuel-needed">-</span>
                        </div>
                        <div class="result-item safe-fuel">
                            <span class="result-label"><?php _e('Safe Fuel (including 2 extra laps):', 'fuel-calculator'); ?></span>
                            <span class="result-value" id="standard-safe-fuel">-</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Advanced Calculator Tab -->
            <div id="advanced-tab" class="tab-content" style="display: none;">
                <div class="calculator-card">
                    <h2><?php _e('Advanced Multi-Stint Calculator', 'fuel-calculator'); ?></h2>
                    
                    <div class="input-group">
                        <label><?php _e('Tank Capacity', 'fuel-calculator'); ?></label>
                        <div class="input-wrapper">
                            <input type="number" id="tank-capacity" min="1" max="200" value="60" onchange="calculateAdvanced()">
                            <span class="unit"><?php _e('L', 'fuel-calculator'); ?></span>
                        </div>
                    </div>
                    
                    <div class="input-group">
                        <label><?php _e('Fuel Per Lap', 'fuel-calculator'); ?></label>
                        <div class="input-wrapper">
                            <input type="number" id="adv-fuel-per-lap" min="0.1" max="20" step="0.1" value="2.8" onchange="calculateAdvanced()">
                            <span class="unit"><?php _e('L', 'fuel-calculator'); ?></span>
                        </div>
                    </div>
                    
                    <h3><?php _e('Stints', 'fuel-calculator'); ?></h3>
                    <div id="stints-container">
                        <!-- Dynamic stints will be added here -->
                    </div>
                    
                    <button class="add-stint-btn" onclick="addStint()"><?php _e('+ Add Stint', 'fuel-calculator'); ?></button>
                    
                    <!-- Results Section -->
                    <div class="results-section">
                        <h3><?php _e('Results', 'fuel-calculator'); ?></h3>
                        <div class="result-item">
                            <span class="result-label"><?php _e('Total Race Laps:', 'fuel-calculator'); ?></span>
                            <span class="result-value" id="advanced-total-laps">-</span>
                        </div>
                        <div class="result-item">
                            <span class="result-label"><?php _e('Total Fuel Used:', 'fuel-calculator'); ?></span>
                            <span class="result-value" id="advanced-total-fuel">-</span>
                        </div>
                        <div class="result-item">
                            <span class="result-label"><?php _e('Number of Stints:', 'fuel-calculator'); ?></span>
                            <span class="result-value" id="advanced-stint-count">-</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php
        return ob_get_clean();
    }
}