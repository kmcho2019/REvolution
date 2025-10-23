module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Directly assign heater based on mode and too_cold, maintaining minimal logic complexity
    assign heater = mode && too_cold;
    
    // Directly assign aircon based on the inverse of mode and too_hot, ensuring minimal switching activity
    assign aircon =!mode && too_hot;  // Using!mode instead of ~mode for consistency in notation
    
    // Optimize fan logic by reusing heater and aircon signals, minimizing area usage and switching activity
    assign fan = (heater || aircon) || fan_on;

endmodule