module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Explicit state signals for better optimization
    wire heating_active = mode & too_cold;
    wire cooling_active = ~mode & too_hot;

    // Primary outputs
    assign heater = heating_active;
    assign aircon = cooling_active;
    
    // Optimized fan control - single OR operation with parallel inputs
    assign fan = fan_on | heating_active | cooling_active;

endmodule