module TopModule (
    input  wire mode,       // 1: heating mode, 0: cooling mode
    input  wire too_cold,   // 1 if temperature is too cold
    input  wire too_hot,    // 1 if temperature is too hot
    input  wire fan_on,     // User request to turn on fan
    output wire heater,     // Heater control output
    output wire aircon,     // Air conditioner control output
    output wire fan         // Fan control output
);

    // Heater is on only in heating mode and when too cold
    assign heater = mode & too_cold;

    // Air conditioner is on only in cooling mode and when too hot
    assign aircon = (~mode) & too_hot;

    // Precompute whether HVAC (heater or aircon) is active
    wire hvac_on = heater | aircon;

    // Fan is on if HVAC active or user requests fan_on
    assign fan = hvac_on | fan_on;

endmodule