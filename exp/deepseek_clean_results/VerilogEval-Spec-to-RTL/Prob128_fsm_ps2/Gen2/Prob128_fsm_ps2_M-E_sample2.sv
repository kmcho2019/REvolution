module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // 3-byte shift register (byte[0] is newest, byte[2] is oldest)
    reg [7:0] byte_reg [2:0];
    reg [1:0] shift_ptr;

    always @(posedge clk) begin
        if (reset) begin
            // Clear shift register
            byte_reg[0] <= 8'b0;
            byte_reg[1] <= 8'b0;
            byte_reg[2] <= 8'b0;
            shift_ptr <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_reg[0] <= in;
            byte_reg[1] <= byte_reg[0];
            byte_reg[2] <= byte_reg[1];
            
            // Check for complete message
            done <= (byte_reg[2][3] == 1'b1);
        end
    end

endmodule