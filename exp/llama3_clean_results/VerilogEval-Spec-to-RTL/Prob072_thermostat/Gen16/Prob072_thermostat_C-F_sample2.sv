module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Directly assign heater and aircon based on mode and temperature conditions
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Simplified logic for fan by directly considering the states of heater and aircon
    assign fan = (heater | aircon) | fan_on;

endmodule