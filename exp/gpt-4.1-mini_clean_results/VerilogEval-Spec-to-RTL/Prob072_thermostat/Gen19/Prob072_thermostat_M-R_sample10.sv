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
        // Default outputs off
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        if (mode) begin
            // Heating mode: heater on when too cold
            if (too_cold) begin
                heater = 1'b1;
                fan = 1'b1;
            end
        end else begin
            // Cooling mode: aircon on when too hot
            if (too_hot) begin
                aircon = 1'b1;
                fan = 1'b1;
            end
        end

        // Fan also on if user requested fan_on
        if (fan_on)
            fan = 1'b1;
    end

endmodule