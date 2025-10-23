module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only in heating mode when too cold
    assign heater = mode & too_cold;

    // Air conditioner is on only in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Fan turns on if heater or aircon is on, or user requests fan_on
    assign fan = heater | aircon | fan_on;

endmodule