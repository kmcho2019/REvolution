module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // The heater is on when it's too cold in heating mode
    assign heater = mode & too_cold;

    // The air conditioner is on when it's too hot in cooling mode
    assign aircon = ~mode & too_hot;

    // The fan is on when the heater or air conditioner is on, or when the user requests it
    assign fan = (heater | aircon) | fan_on;

endmodule