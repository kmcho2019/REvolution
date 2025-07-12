module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn on the heater if it's too cold
    // In cooling mode, turn on the air conditioner if it's too hot
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn on the fan if the heater or air conditioner is on, or if the user requests it
    assign fan = (heater | aircon) | fan_on;

endmodule