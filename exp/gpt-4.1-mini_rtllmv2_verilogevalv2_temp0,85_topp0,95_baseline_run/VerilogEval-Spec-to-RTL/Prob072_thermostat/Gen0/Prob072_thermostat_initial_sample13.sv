module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon is on in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Fan is on if heater or aircon are on, or if fan_on is asserted
    assign fan = heater | aircon | fan_on;

endmodule