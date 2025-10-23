module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn the heater on when it is too cold
    assign heater = mode & too_cold;

    // In cooling mode, turn the air conditioner on when it is too hot
    assign aircon = ~mode & too_hot;

    // Turn on the fan when the heater or air conditioner are on, or when the user requests it
    assign fan = (heater | aircon) | fan_on;

endmodule