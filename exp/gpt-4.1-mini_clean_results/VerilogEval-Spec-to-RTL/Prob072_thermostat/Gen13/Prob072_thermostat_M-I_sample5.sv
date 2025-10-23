module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);
    wire heating_active = mode & too_cold;
    wire cooling_active = ~mode & too_hot;

    assign heater = heating_active;
    assign aircon = cooling_active;
    assign fan = heating_active | cooling_active | fan_on;
endmodule