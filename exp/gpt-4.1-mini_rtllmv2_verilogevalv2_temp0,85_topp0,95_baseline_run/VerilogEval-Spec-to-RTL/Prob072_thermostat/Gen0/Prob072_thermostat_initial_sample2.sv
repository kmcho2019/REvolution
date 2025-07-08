module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only in heating mode and when too cold
    assign heater = mode & too_cold;

    // Air conditioner is on only in cooling mode and when too hot
    assign aircon = (~mode) & too_hot;

    // Fan is on when heater or aircon is on, or fan_on is asserted
    assign fan = heater | aircon | fan_on;

endmodule