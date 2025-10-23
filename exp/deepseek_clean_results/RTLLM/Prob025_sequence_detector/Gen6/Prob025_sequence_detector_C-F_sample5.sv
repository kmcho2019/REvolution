module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Hybrid approach: 3-bit shift register + minimal state machine
reg [2:0] shift_reg;
reg state; // 0=IDLE, 1=WAIT_FOR_LAST_1

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Shift register updates
        shift_reg <= {shift_reg[1:0], data_in};
        
        // State transitions
        case (state)
            1'b0: // IDLE
                state <= (shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? 1'b1 : 1'b0;
            
            1'b1: // WAIT_FOR_LAST_1
                state <= 1'b0;
        endcase
        
        // Output logic (registered)
        sequence_detected <= (state && data_in) && (shift_reg == 3'b100);
    end
end

endmodule