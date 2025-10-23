module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    // Heater is ON only in heating mode when it is too cold
    assign heater = mode & too_cold;

    // Air conditioner is ON only in cooling mode when it is too hot
    assign aircon = (~mode) & too_hot;

    // Fan is ON if heater or air conditioner is ON, or if manually requested
    assign fan = heater | aircon | fan_on;

endmodule