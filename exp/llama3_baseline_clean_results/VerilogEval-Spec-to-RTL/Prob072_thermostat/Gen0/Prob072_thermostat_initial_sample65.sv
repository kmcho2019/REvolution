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
    assign heater = (mode == 1'b1) && (too_cold == 1'b1);
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);

    // Turn on the fan when the heater or air conditioner is on, or when fan_on is high
    assign fan = (heater == 1'b1) || (aircon == 1'b1) || (fan_on == 1'b1);

endmodule