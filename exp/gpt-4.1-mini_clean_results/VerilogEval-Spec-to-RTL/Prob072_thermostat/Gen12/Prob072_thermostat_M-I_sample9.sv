module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);
    wire heat_active = mode & too_cold;
    wire cool_active = ~mode & too_hot;
    assign heater = heat_active;
    assign aircon = cool_active;
    assign fan = heat_active | cool_active | fan_on;
endmodule