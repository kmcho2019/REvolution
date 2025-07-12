module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output reg heater,    // Heater control output
    output reg aircon,    // Air conditioner control output
    output reg fan        // Fan control output
);

    always @(*) begin
        // Determine heater state: on only in heating mode and too cold
        heater = (mode == 1'b1) && (too_cold == 1'b1);
        
        // Determine aircon state: on only in cooling mode and too hot
        aircon = (mode == 1'b0) && (too_hot == 1'b1);
        
        // Fan is on if heater or aircon is on, or if user manually requests it
        fan = heater || aircon || (fan_on == 1'b1);
    end

endmodule