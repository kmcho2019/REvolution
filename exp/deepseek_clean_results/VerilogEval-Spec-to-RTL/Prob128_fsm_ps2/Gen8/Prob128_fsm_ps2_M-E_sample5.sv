module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // 3-byte shift register to hold recent bytes
    reg [7:0] byte_reg [2:0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            // Clear shift register on reset
            for (i = 0; i < 3; i = i + 1)
                byte_reg[i] <= 8'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_reg[2] <= byte_reg[1];
            byte_reg[1] <= byte_reg[0];
            byte_reg[0] <= in;

            // Check if current window forms a valid message
            // (byte_reg[2] is start byte, followed by any two bytes)
            done <= byte_reg[2][3] & (byte_reg[1][3] | ~byte_reg[1][3]) & 
                   (byte_reg[0][3] | ~byte_reg[0][3]);
        end
    end

endmodule