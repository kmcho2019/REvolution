module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Direct assignments for heater and aircon based on mode and temperature conditions
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Simplified fan control logic considering heater, aircon, and fan_on
    assign fan = (heater | aircon | fan_on);

endmodule