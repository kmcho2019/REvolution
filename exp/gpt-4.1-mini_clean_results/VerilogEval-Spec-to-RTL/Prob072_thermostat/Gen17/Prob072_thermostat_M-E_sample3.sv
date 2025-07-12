module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output reg heater, // Heater control output
    output reg aircon, // Air conditioner control output
    output reg fan     // Fan control output
);

    always @* begin
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        case (mode)
            1'b1: begin // Heating mode
                if (too_cold) begin
                    heater = 1'b1;
                end
            end
            1'b0: begin // Cooling mode
                if (too_hot) begin
                    aircon = 1'b1;
                end
            end
        endcase

        // Fan is on if heater or aircon is on or user requests it
        if (heater || aircon || fan_on) begin
            fan = 1'b1;
        end
    end

endmodule