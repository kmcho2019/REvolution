module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine whether the heater or air conditioner should be turned on
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn on the fan if the heater, air conditioner, or fan_on is on
    assign fan = heater | aircon | fan_on;

endmodule