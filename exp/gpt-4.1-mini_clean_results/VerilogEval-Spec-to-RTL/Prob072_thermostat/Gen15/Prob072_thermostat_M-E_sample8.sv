module TopModule(
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        if (mode) begin
            // Heating mode
            heater = too_cold ? 1'b1 : 1'b0;
            aircon = 1'b0;
        end else begin
            // Cooling mode
            heater = 1'b0;
            aircon = too_hot ? 1'b1 : 1'b0;
        end
        // Fan is on if heater or aircon is on, or user requested fan_on
        fan = heater | aircon | fan_on;
    end

endmodule