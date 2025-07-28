<?php
/**
 * Plugin Name: Fuel Calculator for Sim Racing
 * Plugin URI: https://simracingcockpit.gg/fuel-calculator
 * Description: Calculate optimal fuel loads for sim racing. Supports both time and lap-based races with multi-stint planning.
 * Version: 1.1.0
 * Author: Richard Baxter
 * Author URI: https://simracingcockpit.gg
 * License: GPL v2 or later
 * Text Domain: fuel-calculator
 * Domain Path: /languages
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Define plugin constants
define('FUEL_CALC_VERSION', '1.1.0');
define('FUEL_CALC_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('FUEL_CALC_PLUGIN_URL', plugin_dir_url(__FILE__));
define('FUEL_CALC_PLUGIN_FILE', __FILE__);

// Include the main plugin class
require_once FUEL_CALC_PLUGIN_DIR . 'includes/class-fuel-calculator.php';

// Initialize the plugin
function fuel_calculator_init() {
    $plugin = new Fuel_Calculator();
    $plugin->init();
}
add_action('plugins_loaded', 'fuel_calculator_init');

// Activation hook
register_activation_hook(__FILE__, 'fuel_calculator_activate');
function fuel_calculator_activate() {
    // Add any activation tasks here
    flush_rewrite_rules();
}

// Deactivation hook
register_deactivation_hook(__FILE__, 'fuel_calculator_deactivate');
function fuel_calculator_deactivate() {
    // Add any deactivation tasks here
    flush_rewrite_rules();
}
