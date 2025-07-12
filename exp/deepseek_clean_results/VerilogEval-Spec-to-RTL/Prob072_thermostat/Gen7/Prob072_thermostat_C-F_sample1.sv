module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is active only in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon is active only in cooling mode when too hot
    // Note: heater and aircon are mutually exclusive due to mode
    assign aircon = ~mode & too_hot;

    // Fan is active when requested or when either heater or aircon is on
    // fan_on placed first for potential switching optimization
    assign fan = fan_on | heater | aircon;

endmodule