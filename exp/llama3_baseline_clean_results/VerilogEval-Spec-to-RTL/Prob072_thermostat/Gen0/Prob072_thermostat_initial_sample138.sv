module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn on the heater when it's too cold
    // In cooling mode, turn on the air conditioner when it's too hot
    assign heater = mode && too_cold;
    assign aircon = ~mode && too_hot;

    // Turn on the fan when either the heater or air conditioner is on, or when the user requests the fan to be on
    assign fan = heater || aircon || fan_on;

endmodule