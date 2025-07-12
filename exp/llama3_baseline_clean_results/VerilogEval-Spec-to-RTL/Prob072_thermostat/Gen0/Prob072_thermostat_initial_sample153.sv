module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // The heater is turned on in heating mode when it's too cold
    assign heater = mode & too_cold;

    // The air conditioner is turned on in cooling mode when it's too hot
    assign aircon = ~mode & too_hot;

    // The fan is turned on when the heater or air conditioner is on, or when fan_on is 1
    assign fan = (heater | aircon) | fan_on;

endmodule