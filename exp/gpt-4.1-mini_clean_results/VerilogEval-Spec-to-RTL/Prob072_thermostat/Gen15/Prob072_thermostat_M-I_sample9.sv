module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on in heating mode and when too cold
    assign heater = mode & too_cold;

    // Air conditioner is on in cooling mode and when too hot
    assign aircon = ~mode & too_hot;

    // Fan is on if heater or aircon is on, or user forces fan_on
    assign fan = heater | aircon | fan_on;

endmodule