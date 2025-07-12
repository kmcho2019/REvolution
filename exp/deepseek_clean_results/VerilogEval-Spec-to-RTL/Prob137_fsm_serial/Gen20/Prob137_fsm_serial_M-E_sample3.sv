module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // 10-bit shift register: [stop][d7..d0][start]
    reg [9:0] shift_reg;
    reg done_reg;
    reg receiving;
    wire valid_stop = shift_reg[9];  // Stop bit should be 1
    wire byte_complete = &shift_reg[9:1];  // All data and stop bits received
    
    // Shift register with integrated protocol tracking
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b1111111111;  // Idle state (all 1's)
            receiving <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            // Default shift operation
            shift_reg <= {shift_reg[8:0], in};
            
            // Protocol state tracking
            if (!receiving) begin
                // Wait for start bit (0)
                if (!in) begin
                    receiving <= 1'b1;
                    shift_reg <= {9'b111111111, in};  // Initialize with start bit
                end
            end else begin
                // Check for early termination conditions
                if (shift_reg[8] && !in) begin  // Expected stop bit is 0 (error)
                    receiving <= 1'b0;  // Abort reception
                end
                
                // Complete reception when stop bit is received
                if (byte_complete) begin
                    receiving <= 1'b0;
                    done_reg <= 1'b1;
                end else begin
                    done_reg <= 1'b0;
                end
            end
        end
    end

    assign done = done_reg;

endmodule