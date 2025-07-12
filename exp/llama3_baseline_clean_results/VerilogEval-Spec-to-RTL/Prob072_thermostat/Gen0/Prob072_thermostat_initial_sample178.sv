module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn the heater on when it's too cold
    assign heater = (mode == 1'b1) && (too_cold == 1'b1);

    // In cooling mode, turn the air conditioner on when it's too hot
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);

    // Turn on the fan when the heater or air conditioner is on, or when fan_on is high
    assign fan = (heater == 1'b1) || (aircon == 1'b1) || (fan_on == 1'b1);

endmodule