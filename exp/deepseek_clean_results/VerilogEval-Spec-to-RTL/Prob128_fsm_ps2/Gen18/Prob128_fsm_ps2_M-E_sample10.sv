module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_shift_reg;
    wire byte1_valid = byte_shift_reg[19];  // in[3] of first byte in window

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            
            // Check if we have a complete message (3 bytes) where first byte has in[3]=1
            done <= &byte_shift_reg[23:16] ? 1'b0 :  // Prevent false positive when shift reg is empty
                   (byte1_valid && (byte_shift_reg[23:16] != 8'b0));
        end
    end

endmodule