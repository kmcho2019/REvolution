module TopModule(
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    // Invert mode once to save inverter gate and power
    wire mode_inv = ~mode;

    // Heater is on in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon is on in cooling mode when too hot
    assign aircon = mode_inv & too_hot;

    // Fan is on if heater or aircon active, or user forces fan on
    assign fan = heater | aircon | fan_on;

endmodule