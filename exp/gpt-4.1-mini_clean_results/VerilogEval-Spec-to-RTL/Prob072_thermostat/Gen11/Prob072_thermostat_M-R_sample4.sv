module TopModule (
    input  wire mode,      // 1: heating mode, 0: cooling mode
    input  wire too_cold,  // 1 if temperature is too cold
    input  wire too_hot,   // 1 if temperature is too hot
    input  wire fan_on,    // User request to turn on fan
    output reg heater,     // Heater control output
    output reg aircon,     // Air conditioner control output
    output reg fan         // Fan control output
);

    always @(*) begin
        if (mode) begin
            heater = too_cold;
            aircon = 1'b0;
        end else begin
            heater = 1'b0;
            aircon = too_hot;
        end
        fan = heater | aircon | fan_on;
    end

endmodule