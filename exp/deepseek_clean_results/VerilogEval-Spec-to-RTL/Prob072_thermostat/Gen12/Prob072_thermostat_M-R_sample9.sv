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
        heater = 1'b0;
        aircon = 1'b0;
        
        // Mode-based temperature control
        case (mode)
            1'b1: heater = too_cold;  // Heating mode
            1'b0: aircon = too_hot;    // Cooling mode
        endcase
        
        // Fan control (user request OR active temp control)
        fan = fan_on || heater || aircon;
    end

endmodule