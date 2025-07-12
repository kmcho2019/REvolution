module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Shared temperature control logic
    wire temp_control = mode ? too_cold : too_hot;
    
    // Heater and aircon are mutually exclusive based on mode
    assign heater = mode & temp_control;
    assign aircon = ~mode & temp_control;
    
    // Optimized fan control - fan_on has priority
    assign fan = fan_on | (heater | aircon);

endmodule