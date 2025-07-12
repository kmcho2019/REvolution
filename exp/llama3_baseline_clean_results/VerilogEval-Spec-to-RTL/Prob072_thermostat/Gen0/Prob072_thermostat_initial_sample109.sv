module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn on the heater if it's too cold
    assign heater = (mode == 1'b1) && (too_cold == 1'b1);

    // In cooling mode, turn on the air conditioner if it's too hot
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);

    // Turn on the fan if either the heater or air conditioner is on, or if the user requests it
    assign fan = (heater == 1'b1) || (aircon == 1'b1) || (fan_on == 1'b1);

endmodule