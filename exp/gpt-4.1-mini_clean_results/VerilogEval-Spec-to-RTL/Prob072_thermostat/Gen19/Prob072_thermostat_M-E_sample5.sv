module TopModule (
    input  wire mode,       // 1: heating mode, 0: cooling mode
    input  wire too_cold,   // 1 if temperature is too cold
    input  wire too_hot,    // 1 if temperature is too hot
    input  wire fan_on,     // User request to turn on fan
    output reg  heater,     // Heater control output
    output reg  aircon,     // Air conditioner control output
    output reg  fan         // Fan control output
);

    always @(*) begin
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan    = 1'b0;

        if (mode) begin
            // Heating mode
            if (too_cold) begin
                heater = 1'b1;
                fan    = 1'b1;
            end
        end
        else begin
            // Cooling mode
            if (too_hot) begin
                aircon = 1'b1;
                fan    = 1'b1;
            end
        end

        // Override fan if user wants it on
        if (fan_on)
            fan = 1'b1;
    end

endmodule