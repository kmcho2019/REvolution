module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Hybrid approach: 3-bit shift register + minimal state machine
reg [2:0] shift_reg;
reg state; // 0=IDLE, 1=MATCHING (after detecting "10")

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update shift register
        shift_reg <= {shift_reg[1:0], data_in};
        
        // State transitions and output generation
        case (state)
            1'b0: begin // IDLE
                // Transition to MATCHING when we see "10" and next bit is 0
                state <= (shift_reg[1:0] == 2'b10 && data_in == 1'b0);
                sequence_detected <= 1'b0;
            end
            
            1'b1: begin // MATCHING
                // Sequence complete when we see "1001" (last bit is 1)
                sequence_detected <= data_in;
                // Always return to IDLE after checking final bit
                state <= 1'b0;
            end
        endcase
    end
end

endmodule