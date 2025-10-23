module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // One-hot encoded states
    localparam IDLE     = 3'b000;
    localparam HEATING  = 3'b001;
    localparam COOLING  = 3'b010;
    localparam FAN_ONLY = 3'b100;

    reg [2:0] state;

    always @(*) begin
        case (1'b1)
            // Heating mode active
            (mode & too_cold): begin
                state = HEATING;
                heater = 1'b1;
                aircon = 1'b0;
                fan = 1'b1;
            end
            
            // Cooling mode active
            (~mode & too_hot): begin
                state = COOLING;
                heater = 1'b0;
                aircon = 1'b1;
                fan = 1'b1;
            end
            
            // Fan only requested
            (fan_on): begin
                state = FAN_ONLY;
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b1;
            end
            
            // Default idle state
            default: begin
                state = IDLE;
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
        endcase
    end

endmodule