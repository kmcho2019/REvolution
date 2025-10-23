module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Directly assign heater based on mode and too_cold, optimizing for minimal switching activity
    assign heater = mode && too_cold;
    
    // Directly assign aircon based on the inverse of mode and too_hot, ensuring minimal logic complexity
    assign aircon = ~mode && too_hot;
    
    // Optimize fan logic by reusing heater and aircon signals, minimizing area usage and switching activity
    assign fan = (heater || aircon) || fan_on;

endmodule