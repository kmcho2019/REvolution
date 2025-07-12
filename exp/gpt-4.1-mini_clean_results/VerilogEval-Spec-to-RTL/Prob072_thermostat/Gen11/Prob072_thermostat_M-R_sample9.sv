module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output reg heater,    // Heater control output
    output reg aircon,    // Air conditioner control output
    output reg fan        // Fan control output
);

    always @* begin
        if (mode) begin
            // Heating mode: heater on if too cold, aircon off
            heater = too_cold;
            aircon = 1'b0;
        end else begin
            // Cooling mode: aircon on if too hot, heater off
            heater = 1'b0;
            aircon = too_hot;
        end

        // Fan on if heater or aircon on, or manual fan_on request
        fan = heater | aircon | fan_on;
    end

endmodule