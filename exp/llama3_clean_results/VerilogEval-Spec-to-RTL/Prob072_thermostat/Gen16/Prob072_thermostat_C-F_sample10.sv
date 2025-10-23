module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heating_mode;
    wire cooling_mode;

    assign heating_mode = mode & too_cold;
    assign cooling_mode = ~mode & too_hot;

    assign heater = heating_mode;
    assign aircon = cooling_mode;
    assign fan = (heating_mode | cooling_mode | fan_on);

endmodule