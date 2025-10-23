module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Turn on heater when in heating mode and it's too cold
    assign heater = mode & too_cold;

    // Turn on air conditioner when in cooling mode and it's too hot
    assign aircon = ~mode & too_hot;

    // Turn on fan when heater or air conditioner is on, or when fan_on is asserted
    assign fan = (heater | aircon) | fan_on;

endmodule