module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    // Invert mode once to save inverter gate
    wire mode_inv = ~mode;

    // Heater active when heating mode and temperature is too cold
    assign heater = mode & too_cold;

    // Air conditioner active when cooling mode and temperature is too hot
    assign aircon = mode_inv & too_hot;

    // Fan turns on if heater or aircon active, or manual fan_on request
    assign fan = heater | aircon | fan_on;

endmodule