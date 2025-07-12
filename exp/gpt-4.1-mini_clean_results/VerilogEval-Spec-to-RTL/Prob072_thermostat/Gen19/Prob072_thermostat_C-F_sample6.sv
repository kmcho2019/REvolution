module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    // Heater turns on only in heating mode when too cold
    assign heater = mode & too_cold;

    // Air conditioner turns on only in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Intermediate signal indicating heating or cooling is active
    wire active = heater | aircon;

    // Fan turns on if heater or aircon is on, or user requests fan
    assign fan = active | fan_on;

endmodule