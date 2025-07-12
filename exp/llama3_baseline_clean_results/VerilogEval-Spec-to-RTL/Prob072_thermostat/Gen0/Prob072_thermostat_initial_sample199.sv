module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn heater on if it's too cold
    // In cooling mode, turn air conditioner on if it's too hot
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn fan on if heater or air conditioner is on, or if fan_on is high
    assign fan = (heater | aircon) | fan_on;

endmodule