module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan = fan_on;  // Fan can be on by user request regardless of mode
        
        case (mode)
            1'b1: begin // Heating mode
                heater = too_cold;
                fan = fan_on | too_cold;  // Fan on if heating or user request
            end
            1'b0: begin // Cooling mode
                aircon = too_hot;
                fan = fan_on | too_hot;  // Fan on if cooling or user request
            end
        endcase
    end

endmodule