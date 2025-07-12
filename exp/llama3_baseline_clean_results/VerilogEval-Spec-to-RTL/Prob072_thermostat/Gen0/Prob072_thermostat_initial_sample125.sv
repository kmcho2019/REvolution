module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn the heater on when it's too cold
    // In cooling mode, turn the air conditioner on when it's too hot
    assign heater = mode && too_cold;
    assign aircon = ~mode && too_hot;

    // Turn the fan on if the heater or air conditioner is on, or if the user requests it
    assign fan = heater || aircon || fan_on;

endmodule