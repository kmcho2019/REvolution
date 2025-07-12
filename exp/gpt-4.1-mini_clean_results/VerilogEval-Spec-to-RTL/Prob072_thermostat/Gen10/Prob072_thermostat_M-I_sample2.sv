module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heating_on = mode & too_cold;
    wire cooling_on = ~mode & too_hot;

    assign heater = heating_on;
    assign aircon = cooling_on;
    assign fan = heating_on | cooling_on | fan_on;

endmodule