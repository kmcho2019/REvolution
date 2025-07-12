module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine whether the heater or aircon should be on
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn on the fan if either the heater or aircon is on, or if the fan_on input is high
    assign fan = (heater | aircon) | fan_on;

endmodule