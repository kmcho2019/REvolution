module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    wire heating_or_cooling;

    assign heater = mode & too_cold;
    assign aircon = (~mode) & too_hot;
    assign heating_or_cooling = heater | aircon;
    assign fan = heating_or_cooling | fan_on;

endmodule