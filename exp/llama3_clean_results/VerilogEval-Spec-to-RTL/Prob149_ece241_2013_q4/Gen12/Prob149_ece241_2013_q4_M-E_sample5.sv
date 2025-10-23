module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // FSM state register
reg [1:0] prev_state; // Previous FSM state register

always @(posedge clk) begin
    if (reset) begin
        // Reset to LOW state
        state <= 2'b00;
        prev_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine next state based on sensor inputs
        case (s)
            3'b000: state <= 2'b00; // LOW state
            3'b001: state <= 2'b01; // LOW_MIDDLE state
            3'b011: state <= 2'b10; // MIDDLE_HIGH state
            default: state <= 2'b11; // HIGH state
        endcase
        
        // Determine output signals based on current state
        case (state)
            2'b00: begin // LOW state
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            2'b01: begin // LOW_MIDDLE state
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            2'b10: begin // MIDDLE_HIGH state
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            2'b11: begin // HIGH state
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
        endcase
        
        // Determine supplemental flow rate signal (dfr)
        if (state > prev_state) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
        
        // Update previous state
        prev_state <= state;
    end
end

endmodule