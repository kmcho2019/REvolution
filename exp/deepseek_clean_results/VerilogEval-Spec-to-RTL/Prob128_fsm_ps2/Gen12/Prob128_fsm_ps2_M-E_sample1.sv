module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;
    wire byte1_valid = shift_reg[3];    // First byte's in[3]
    wire byte2_valid = shift_reg[11];   // Second byte's in[3]
    wire byte3_valid = shift_reg[19];   // Third byte's in[3]
    
    // Pattern matching for valid message at any alignment
    wire pattern1_valid = byte1_valid && (shift_reg[23:16] == in);
    wire pattern2_valid = byte2_valid && (shift_reg[15:8] == in);
    wire pattern3_valid = byte3_valid && (shift_reg[7:0] == in);
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            shift_reg <= {shift_reg[15:0], in};
            
            // Check for complete message at any alignment
            done <= pattern1_valid || pattern2_valid || pattern3_valid;
        end
    end

endmodule