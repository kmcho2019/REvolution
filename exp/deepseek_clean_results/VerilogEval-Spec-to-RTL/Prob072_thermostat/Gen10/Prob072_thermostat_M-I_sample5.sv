module TopModule (
    input mode,           // 1=heating mode, 0=cooling mode
    input too_cold,       // Temperature is too cold
    input too_hot,        // Temperature is too hot
    input fan_on,         // Manual fan override
    output heater,        // Heater control
    output aircon,        // Air conditioner control
    output fan            // Fan control
);

    // Heater is on only in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon is on only in cooling mode when too hot
    assign aircon = ~mode & too_hot;

    // Fan is on when either heater/aircon is active or manually requested
    assign fan = fan_on | heater | aircon;

endmodule