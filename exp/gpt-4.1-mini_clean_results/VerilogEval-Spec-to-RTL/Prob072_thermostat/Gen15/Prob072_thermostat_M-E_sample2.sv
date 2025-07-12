module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    // Define heating active signal: mode must be heating and temperature too cold
    wire heating_active = mode & too_cold;

    // Define cooling active signal: mode must be cooling and temperature too hot
    wire cooling_active = (~mode) & too_hot;

    assign heater = heating_active;
    assign aircon = cooling_active;

    // Fan logic: if heating or cooling active, fan is on; else, fan follows fan_on input
    assign fan = (heating_active | cooling_active) ? 1'b1 : fan_on;

endmodule