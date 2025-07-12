module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // 3-byte shift register
    reg [7:0] byte_shift [2:0];
    
    always @(posedge clk) begin
        if (reset) begin
            // Clear shift register
            byte_shift[0] <= 8'b0;
            byte_shift[1] <= 8'b0;
            byte_shift[2] <= 8'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift[0] <= in;
            byte_shift[1] <= byte_shift[0];
            byte_shift[2] <= byte_shift[1];
            
            // Check for valid message pattern (first byte has bit 3 set)
            done <= (byte_shift[2][3] && 
                   ($time > 2));  // Ensure we've seen at least 3 bytes
        end
    end

endmodule