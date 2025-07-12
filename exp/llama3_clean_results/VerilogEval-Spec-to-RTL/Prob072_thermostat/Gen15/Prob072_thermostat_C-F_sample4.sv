module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Directly assign heater and aircon based on mode and temperature conditions
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Use a logical OR to combine the conditions for the fan, ensuring fan_on takes precedence when heater and aircon are off
    assign fan = (heater | aircon) | fan_on;

endmodule