// TopModule: A thermostat controller that manages a heater and an air conditioner based on the mode and temperature conditions.
module TopModule(
    input mode,      // Mode of operation: 1 for heating, 0 for cooling
    input too_cold,  // Too cold condition
    input too_hot,   // Too hot condition
    input fan_on,    // Fan on request
    output heater,   // Heater output
    output aircon,   // Air conditioner output
    output fan       // Fan output
);

    // Directly assign outputs based on input conditions for simplicity and efficiency
    assign heater = mode & too_cold;       // Turn heater on if in heating mode and it's too cold
    assign aircon = ~mode & too_hot;       // Turn air conditioner on if in cooling mode and it's too hot
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on; // Turn fan on if heater or air conditioner is on, or fan is requested

endmodule