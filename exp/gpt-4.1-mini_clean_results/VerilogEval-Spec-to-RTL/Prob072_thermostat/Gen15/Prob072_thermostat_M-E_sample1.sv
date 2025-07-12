module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        // Default outputs
        heater = 0;
        aircon = 0;
        
        case (mode)
            1'b1: begin // Heating mode
                if (too_cold)
                    heater = 1;
            end
            1'b0: begin // Cooling mode
                if (too_hot)
                    aircon = 1;
            end
            default: begin
                // Should never occur for 1-bit mode
                heater = 0;
                aircon = 0;
            end
        endcase
        
        // Fan on if heater or aircon is on or user fan_on is asserted
        fan = heater | aircon | fan_on;
    end

endmodule