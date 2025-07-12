module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    // Invert mode once for power and area optimization
    wire mode_inv = ~mode;

    // Heater enabled only in heating mode and if too cold
    wire heat_active = mode & too_cold;

    // Air conditioner enabled only in cooling mode and if too hot
    wire cool_active = mode_inv & too_hot;

    assign heater = heat_active;
    assign aircon = cool_active;

    // Fan enabled if heater or aircon is on, or if user requests it
    assign fan = heat_active | cool_active | fan_on;

endmodule