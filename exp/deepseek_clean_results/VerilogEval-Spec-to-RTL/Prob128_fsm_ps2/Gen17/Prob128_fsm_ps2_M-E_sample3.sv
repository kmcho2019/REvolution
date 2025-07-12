module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte and maintain last 3 bytes
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            
            // Check if oldest byte in window has in[3]=1
            done <= byte_shift_reg[19] & (byte_shift_reg[23:16] != 8'b0);
        end
    end

endmodule