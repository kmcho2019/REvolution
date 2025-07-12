module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Directly assign heater and aircon based on mode and temperature conditions
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Control fan based on heater, aircon, and fan_on, considering mutual exclusivity
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

endmodule