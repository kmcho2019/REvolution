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
    assign heater = mode & too_cold;
    
    // Assign aircon condition directly
    assign aircon = ~mode & too_hot;
    
    // Assign fan condition directly, considering heater, aircon, and fan_on
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

endmodule