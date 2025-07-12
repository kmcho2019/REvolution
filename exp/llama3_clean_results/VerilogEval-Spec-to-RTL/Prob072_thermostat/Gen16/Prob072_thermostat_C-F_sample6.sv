module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heating_required;
    wire cooling_required;
    wire fan_needed;

    assign heating_required = mode & too_cold;
    assign cooling_required = ~mode & too_hot;
    assign fan_needed = (heating_required | cooling_required) | fan_on;

    assign heater = heating_required;
    assign aircon = cooling_required;
    assign fan = fan_needed;

endmodule