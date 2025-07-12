module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Default outputs
    heater = 0;
    aircon = 0;
    fan = fan_on;
    
    case (mode)
        1'b1: begin // Heating mode
            heater = too_cold;
            fan = fan_on || heater;
        end
        1'b0: begin // Cooling mode
            aircon = too_hot;
            fan = fan_on || aircon;
        end
    endcase
end

endmodule