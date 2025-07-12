module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    // Heater is active only in heating mode when too cold
    assign heater = mode & too_cold;

    // Air conditioner is active only in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Combine heater and aircon activity for fan control
    wire active = heater | aircon;

    // Fan runs if heater or aircon is on, or if user manually requests fan_on
    assign fan = active | fan_on;

endmodule