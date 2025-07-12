module TopModule(
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    wire heat_or_cool;
    assign heater = mode & too_cold;
    assign aircon = (~mode) & too_hot;
    assign heat_or_cool = heater | aircon;
    assign fan = heat_or_cool | fan_on;

endmodule