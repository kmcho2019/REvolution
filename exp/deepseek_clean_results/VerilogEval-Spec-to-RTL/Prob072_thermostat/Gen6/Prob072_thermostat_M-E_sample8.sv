module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State definition
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;
    
    reg current_mode;

    always @(*) begin
        current_mode = mode;
        
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan = fan_on;  // Fan has highest priority
        
        // Mode-specific control
        case (current_mode)
            HEATING: begin
                heater = too_cold;
                fan = fan_on | (too_cold & ~fan_on);
            end
            COOLING: begin
                aircon = too_hot;
                fan = fan_on | (too_hot & ~fan_on);
            end
        endcase
    end

endmodule