module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Direct mode-based control for heater/aircon (mutually exclusive)
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Optimized fan logic - fan_on takes priority, then check heater/aircon
    assign fan = fan_on | heater | aircon;

endmodule