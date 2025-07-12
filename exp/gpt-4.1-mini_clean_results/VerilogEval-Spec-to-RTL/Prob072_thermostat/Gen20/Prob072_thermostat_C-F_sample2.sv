module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    // Heater is on only in heating mode and when it's too cold
    assign heater = mode & too_cold;

    // Air conditioner is on only in cooling mode and when it's too hot
    assign aircon = ~mode & too_hot;

    // Fan is on if heater or air conditioner is on, or if user requests fan
    assign fan = heater | aircon | fan_on;

endmodule