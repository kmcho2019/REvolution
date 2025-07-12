module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output reg heater, // Heater control output
    output reg aircon, // Air conditioner control output
    output reg fan     // Fan control output
);

    always @(*) begin
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan    = 1'b0;

        if (mode) begin
            // Heating mode
            if (too_cold)
                heater = 1'b1;
        end else begin
            // Cooling mode
            if (too_hot)
                aircon = 1'b1;
        end

        // Fan on if heater or aircon is active or user requests fan_on
        if (heater || aircon || fan_on)
            fan = 1'b1;
    end

endmodule