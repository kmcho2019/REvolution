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
    
    // Simplify fan control logic considering mutual exclusivity and optimization strategies
    // Directly use heater and aircon signals to reduce switching activity and simplify logic
    assign fan = (heater | aircon) | fan_on;

    // Alternatively, simplify the fan logic further by using a single OR gate
    // assign fan = heater | aircon | fan_on;

endmodule