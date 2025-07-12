module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Assign heater and aircon based on mode and temperature conditions
    // This logic remains unchanged as it directly implements the required functionality
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Simplify the fan control logic by directly considering the mode and temperature conditions
    // Along with the fan_on signal, this logic ensures the fan is on when either the heater or aircon is on, or when fan_on is asserted
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

endmodule