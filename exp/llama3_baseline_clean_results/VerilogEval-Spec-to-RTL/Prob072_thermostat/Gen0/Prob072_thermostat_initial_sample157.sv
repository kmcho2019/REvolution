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
    assign heater = mode & too_cold;

    // In cooling mode, turn the air conditioner on when it's too hot
    assign aircon = ~mode & too_hot;

    // Turn the fan on when the heater or air conditioner are on, or when the fan is requested to be on
    assign fan = (heater | aircon | fan_on);

endmodule