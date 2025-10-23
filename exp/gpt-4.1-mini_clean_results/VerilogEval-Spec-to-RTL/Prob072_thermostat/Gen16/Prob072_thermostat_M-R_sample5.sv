module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    assign heater = mode & too_cold;        // Heater on in heating mode when too cold
    assign aircon = (~mode) & too_hot;      // Aircon on in cooling mode when too hot
    assign fan    = heater | aircon | fan_on; // Fan on if heater, aircon active, or user requests fan_on

endmodule