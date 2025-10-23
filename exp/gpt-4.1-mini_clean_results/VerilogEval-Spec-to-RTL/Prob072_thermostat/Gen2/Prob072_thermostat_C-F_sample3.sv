module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater enabled only in heating mode when too cold
    assign heater = (mode & too_cold);

    // Air conditioner enabled only in cooling mode when too hot
    assign aircon = ((~mode) & too_hot);

    // Fan runs if heater or aircon is on, or fan_on is asserted
    assign fan = (heater | aircon | fan_on);

endmodule