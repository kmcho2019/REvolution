module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only in heating mode when too_cold
    assign heater = mode & too_cold;

    // Aircon is on only in cooling mode when too_hot
    // Note: heater and aircon are mutually exclusive due to mode
    assign aircon = ~mode & too_hot;

    // Fan is on when explicitly requested or when heater/aircon is active
    // fan_on placed first for potential switching optimization
    assign fan = fan_on | heater | aircon;

endmodule