module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Tracks last 3 bits
reg state;            // 0=IDLE, 1=MATCHING

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 3'b0;
        state <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update shift register
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Default output
        sequence_detected <= 1'b0;
        
        case (state)
            1'b0: begin // IDLE state
                // Detect "100" pattern (shift_reg[1:0]=00 with new bit=1)
                if (shift_reg[1:0] == 2'b00 && data_in == 1'b1)
                    state <= 1'b1;  // Transition to MATCHING
            end
            
            1'b1: begin // MATCHING state
                // Complete sequence when we get final '1' after "100"
                if (data_in == 1'b1) begin
                    sequence_detected <= 1'b1;
                    // Check if next sequence might be starting
                    state <= (shift_reg[1:0] == 2'b00) ? 1'b1 : 1'b0;
                end
                // If we don't get the expected '1', return to IDLE
                else if (shift_reg != 3'b100) begin
                    state <= 1'b0;
                end
            end
        endcase
    end
end

endmodule