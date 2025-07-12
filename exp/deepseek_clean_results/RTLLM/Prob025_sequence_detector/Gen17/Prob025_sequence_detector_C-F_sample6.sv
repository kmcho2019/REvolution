module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// 4-bit shift register for complete pattern visibility
reg [3:0] shift_reg;
reg state; // 0=IDLE, 1=MATCHED (output control)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        state <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update shift register every cycle
        shift_reg <= {shift_reg[2:0], data_in};
        
        // State machine for output control
        case (state)
            1'b0: begin // IDLE
                // Transition to MATCHED when pattern detected
                state <= (shift_reg == 4'b1001);
                sequence_detected <= 1'b0;
            end
            
            1'b1: begin // MATCHED
                // Output high for one cycle
                sequence_detected <= 1'b1;
                // Return to IDLE
                state <= 1'b0;
            end
        endcase
    end
end

endmodule