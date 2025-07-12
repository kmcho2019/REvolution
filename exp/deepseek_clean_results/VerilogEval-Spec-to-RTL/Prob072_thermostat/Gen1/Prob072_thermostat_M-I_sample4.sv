module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control - active only in heating mode when too cold
    wire heater_active = mode & too_cold;
    
    // Aircon control - active only in cooling mode when too hot
    wire aircon_active = ~mode & too_hot;
    
    // Output assignments
    assign heater = heater_active;
    assign aircon = aircon_active;
    
    // Optimized fan control:
    // - Turns on for heater/aircon operation
    // - OR when explicitly requested
    // - Implemented with priority to reduce switching
    assign fan = fan_on | heater_active | aircon_active;

endmodule