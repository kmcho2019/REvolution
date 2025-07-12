module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Simplify the logic for heater and aircon
    assign heater = mode && too_cold;
    assign aircon = !mode && too_hot;
    
    // Optimize the fan signal using a single or operation
    assign fan = heater || aircon || fan_on;

endmodule