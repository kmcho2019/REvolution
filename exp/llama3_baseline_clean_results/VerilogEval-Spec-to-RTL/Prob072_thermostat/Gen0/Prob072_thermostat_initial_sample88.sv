module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine the state of the heater and air conditioner
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn on the fan if the heater or air conditioner is on, or if the user requests it
    assign fan = (heater | aircon) | fan_on;

endmodule