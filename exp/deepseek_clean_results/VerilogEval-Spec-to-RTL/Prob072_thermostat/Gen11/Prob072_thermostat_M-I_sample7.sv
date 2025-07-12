module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire not_mode = ~mode;
    
    // Heating control: active only in heating mode when too cold
    assign heater = mode & too_cold;

    // Cooling control: active only in cooling mode when too hot
    assign aircon = not_mode & too_hot;

    // Optimized fan control: 
    // (heater XOR aircon) covers the active heating/cooling cases
    // OR with fan_on for manual override
    assign fan = (heater ^ aircon) | fan_on;

endmodule