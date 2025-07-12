module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is ON only in heating mode when too cold
    assign heater = mode & too_cold;

    // Air conditioner is ON only in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Fan is ON if heater or aircon is ON, or user requests it
    assign fan = heater | aircon | fan_on;

endmodule