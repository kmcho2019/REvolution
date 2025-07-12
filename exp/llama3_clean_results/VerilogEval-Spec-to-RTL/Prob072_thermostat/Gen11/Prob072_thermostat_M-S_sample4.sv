module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Directly generate the heater signal based on mode and too_cold
    assign heater = mode & too_cold;
    
    // Directly generate the aircon signal based on mode and too_hot
    assign aircon = ~mode & too_hot;
    
    // Directly generate the fan signal based on the conditions for heater, aircon, and fan_on
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

endmodule