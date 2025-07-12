module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating control: active only in heating mode when too cold
    assign heater = mode & too_cold;

    // Cooling control: active only in cooling mode when too hot
    assign aircon = ~mode & too_hot;

    // Optimized fan control: 
    // (heater OR aircon) covers active heating/cooling (mutually exclusive)
    // OR with fan_on for manual override
    assign fan = heater | aircon | fan_on;

endmodule