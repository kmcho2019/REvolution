module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Directly assign heater condition
    assign heater = mode && too_cold;
    
    // Directly assign aircon condition
    assign aircon = ~mode && too_hot;
    
    // Simplify fan condition by using previously assigned values
    assign fan = (heater || aircon) || fan_on;

endmodule