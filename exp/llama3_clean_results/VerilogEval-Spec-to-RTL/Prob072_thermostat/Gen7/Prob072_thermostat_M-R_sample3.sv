module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode logic
    wire heating_on;
    assign heating_on = mode & too_cold;
    
    // Cooling mode logic
    wire cooling_on;
    assign cooling_on = ~mode & too_hot;
    
    // Fan logic
    assign fan = heating_on | cooling_on | fan_on;
    
    // Heater and aircon logic
    assign heater = heating_on;
    assign aircon = cooling_on;

endmodule