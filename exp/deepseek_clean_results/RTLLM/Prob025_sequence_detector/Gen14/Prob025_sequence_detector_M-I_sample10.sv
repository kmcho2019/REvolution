module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] shift_reg;  // Reduced from 3-bit to 2-bit
reg state; // 1-bit state encoding (0=IDLE, 1=MATCHING)
reg shift_enable;     // Clock gating control

always @(*) begin
    shift_enable = (state || (shift_reg == 2'b10 && data_in == 1'b0));
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b0;
        state <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update shift register only when needed
        if (shift_enable) begin
            shift_reg <= {shift_reg[0], data_in};
        end
        
        // Default output
        sequence_detected <= 1'b0;
        
        // Simplified state transition logic
        state <= (state && !data_in && shift_reg == 2'b00) ? 1'b1 :  // Stay in MATCHING if pattern continues
                (shift_reg == 2'b10 && data_in == 1'b0) ? 1'b1 :     // Transition to MATCHING
                1'b0;                                                // Default to IDLE
        
        // Output detection
        if (state && data_in) begin
            sequence_detected <= 1'b1;
        end
    end
end

endmodule