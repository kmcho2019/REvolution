module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Hybrid approach: 3-bit shift register + optimized state machine
reg [2:0] shift_reg;
reg state; // 0=IDLE, 1=MATCHING

// Shift register update
wire [2:0] shift_reg_next = {shift_reg[1:0], data_in};

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 3'b0;
        state <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        shift_reg <= shift_reg_next;
        
        // State machine logic
        case (state)
            1'b0: begin // IDLE
                // Transition to MATCHING when we see "10" pattern
                if (shift_reg[1:0] == 2'b10 && data_in == 1'b0) begin
                    state <= 1'b1;
                end
                sequence_detected <= 1'b0;
            end
            
            1'b1: begin // MATCHING
                // Complete sequence detected when last bit is 1 ("1001")
                sequence_detected <= data_in;
                state <= 1'b0; // Return to IDLE
            end
        endcase
    end
end

endmodule