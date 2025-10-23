module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // heater is on when mode is heating and it is too cold
    assign heater = mode & too_cold;

    // air conditioner is on when mode is cooling and it is too hot
    assign aircon = ~mode & too_hot;

    // fan is on when either heater or air conditioner is on, or when fan_on signal is asserted
    assign fan = (heater | aircon) | fan_on;

endmodule