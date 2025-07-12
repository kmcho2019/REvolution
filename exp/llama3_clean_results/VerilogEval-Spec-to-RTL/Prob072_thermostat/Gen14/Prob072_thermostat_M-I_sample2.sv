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
    
    // Use the ternary operator for a concise expression of conditions for the fan
    // This line could potentially be optimized based on the frequency of the inputs,
    // but without further information, the current implementation is straightforward and efficient.
    assign fan = (heater | aircon) | fan_on;

endmodule