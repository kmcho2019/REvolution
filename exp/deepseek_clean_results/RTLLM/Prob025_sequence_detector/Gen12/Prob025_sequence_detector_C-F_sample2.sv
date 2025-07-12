module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;
reg state; // 1-bit state encoding (0=IDLE, 1=MATCHING)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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
            1'b0: begin // IDLE
                if (shift_reg[1:0] == 2'b10 && data_in == 1'b0)
                    state <= 1'b1; // Transition to MATCHING
            end
            
            1'b1: begin // MATCHING
                if (data_in) begin
                    sequence_detected <= 1'b1; // Complete "1001" detected
                    state <= 1'b0; // Return to IDLE
                end
                else if (shift_reg[1:0] != 2'b10) begin
                    state <= 1'b0; // Abort if pattern broken
                end
            end
        endcase
    end
end

endmodule