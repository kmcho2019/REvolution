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
    assign heater = (mode & too_cold);

    // Aircon is active only in cooling mode when too hot
    assign aircon = (~mode & too_hot);

    // Fan is active when heating/cooling or when explicitly requested
    // Reordered for potential power optimization
    assign fan = (heater | aircon | fan_on);

endmodule