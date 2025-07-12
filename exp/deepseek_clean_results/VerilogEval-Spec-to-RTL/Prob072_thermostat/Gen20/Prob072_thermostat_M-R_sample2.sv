module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode controls
    wire heating_active = mode & too_cold;
    
    // Cooling mode controls
    wire cooling_active = ~mode & too_hot;
    
    // Output assignments
    assign heater = heating_active;
    assign aircon = cooling_active;
    assign fan = fan_on | heating_active | cooling_active;

endmodule