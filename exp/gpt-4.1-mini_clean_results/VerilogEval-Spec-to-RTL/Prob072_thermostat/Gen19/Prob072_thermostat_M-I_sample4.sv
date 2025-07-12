module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    wire heater_w  = mode ? too_cold : 1'b0;
    wire aircon_w  = mode ? 1'b0 : too_hot;

    assign heater = heater_w;
    assign aircon = aircon_w;
    assign fan = heater_w | aircon_w | fan_on;

endmodule