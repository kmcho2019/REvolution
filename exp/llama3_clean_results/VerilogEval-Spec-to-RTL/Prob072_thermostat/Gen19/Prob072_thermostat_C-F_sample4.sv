// TopModule: A thermostat controller that manages a heater, air conditioner, and fan based on mode and temperature conditions.

module TopModule(
    input mode,         // Mode of operation: 1 for heating, 0 for cooling
    input too_cold,     // Indicator if it's too cold
    input too_hot,      // Indicator if it's too hot
    input fan_on,       // Request to turn the fan on
    output heater,      // Heater control signal
    output aircon,      // Air conditioner control signal
    output fan          // Fan control signal
);

    // Determine heater state based on mode and temperature
    assign heater = mode & too_cold;  // Turn heater on if in heating mode and it's too cold
    
    // Determine air conditioner state based on mode and temperature
    assign aircon = ~mode & too_hot;  // Turn air conditioner on if in cooling mode and it's too hot
    
    // Determine fan state based on heater, air conditioner, and fan_on
    assign fan = (heater | aircon | fan_on);  // Turn fan on if heater or air conditioner is on, or if fan_on is requested

endmodule