module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater on in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon on in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Fan on if heater or aircon is on, or if fan_on is set
    assign fan = heater | aircon | fan_on;

endmodule