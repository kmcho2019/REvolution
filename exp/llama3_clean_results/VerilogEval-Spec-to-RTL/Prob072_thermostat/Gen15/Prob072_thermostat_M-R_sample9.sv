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
    wire fan_required;

    assign heating_mode = mode & too_cold;
    assign cooling_mode = ~mode & too_hot;
    assign fan_required = heating_mode | cooling_mode | fan_on;

    assign heater = heating_mode;
    assign aircon = cooling_mode;
    assign fan = fan_required;

endmodule