module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_int, aircon_int;

    // Heater is ON only in heating mode (mode=1) when it's too cold
    assign heater_int = mode & too_cold;

    // Air conditioner is ON only in cooling mode (mode=0) when it's too hot
    assign aircon_int = (~mode) & too_hot;

    // Connect outputs
    assign heater = heater_int;
    assign aircon = aircon_int;

    // Fan is ON if heater or air conditioner is ON, or if user manually requests fan
    assign fan = heater_int | aircon_int | fan_on;

endmodule