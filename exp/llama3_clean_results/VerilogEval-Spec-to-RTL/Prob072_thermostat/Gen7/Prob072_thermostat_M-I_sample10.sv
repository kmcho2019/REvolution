module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Assign heater condition directly
    assign heater = mode && too_cold;
    
    // Assign aircon condition directly
    assign aircon = ~mode && too_hot;
    
    // Simplify fan condition by directly using heater, aircon, and fan_on
    assign fan = heater || aircon || fan_on;

endmodule