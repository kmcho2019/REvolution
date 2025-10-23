module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon is on only in cooling mode when too hot
    assign aircon = ~mode & too_hot;

    // Fan is on when explicitly requested or when either heater or aircon is active
    assign fan = fan_on | (heater | aircon);

endmodule