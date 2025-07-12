module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Simplified and direct assignment for heater condition
    assign heater = mode & too_cold;
    
    // Simplified and direct assignment for aircon condition
    assign aircon = ~mode & too_hot;
    
    // Assign fan condition considering heater, aircon, and fan_on
    // This ensures fan is on when either heater or aircon is on, or fan_on is high
    assign fan = (heater | aircon) | fan_on;

endmodule