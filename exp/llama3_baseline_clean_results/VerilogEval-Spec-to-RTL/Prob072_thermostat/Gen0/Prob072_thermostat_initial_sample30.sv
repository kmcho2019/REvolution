module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine whether to turn on the heater or air conditioner based on the mode
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn on the fan whenever the heater or air conditioner is on, or when the fan_on signal is asserted
    assign fan = heater | aircon | fan_on;

endmodule