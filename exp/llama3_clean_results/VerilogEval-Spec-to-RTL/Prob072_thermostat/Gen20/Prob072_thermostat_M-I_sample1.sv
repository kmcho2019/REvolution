module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Directly calculate the heater signal based on mode and too_cold
    assign heater = mode && too_cold;
    
    // Directly calculate the aircon signal based on mode and too_hot
    assign aircon = ~mode && too_hot;
    
    // The fan should be on if either the heater or aircon is on, or if fan_on is requested
    // Using an OR gate for fan control seems to be the most efficient implementation
    assign fan = (heater || aircon) || fan_on;

endmodule