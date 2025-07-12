module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State encoding
    localparam COOLING = 1'b0;
    localparam HEATING = 1'b1;
    
    reg current_state;

    always @(*) begin
        current_state = mode; // Simple state assignment based on mode
        
        case (current_state)
            HEATING: begin
                heater = too_cold;
                aircon = 1'b0;
                fan = fan_on | heater;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = too_hot;
                fan = fan_on | aircon;
            end
        endcase
    end

endmodule