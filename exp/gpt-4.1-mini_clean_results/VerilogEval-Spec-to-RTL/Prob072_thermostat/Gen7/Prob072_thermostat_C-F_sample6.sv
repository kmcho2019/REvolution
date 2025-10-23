module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is ON only in heating mode (mode=1) when it's too cold
    assign heater = mode & too_cold;

    // Air conditioner is ON only in cooling mode (mode=0) when it's too hot
    assign aircon = (~mode) & too_hot;

    // Fan is ON if heater or air conditioner is ON, or if user manually requests fan
    assign fan = heater | aircon | fan_on;

endmodule