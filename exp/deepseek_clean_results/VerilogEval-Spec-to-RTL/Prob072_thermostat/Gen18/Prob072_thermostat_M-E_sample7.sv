module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode: heater on when too_cold, never aircon
    // Cooling mode: aircon on when too_hot, never heater
    // Fan on when either heater, aircon, or manual fan request
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = fan_on | heater | aircon;

endmodule