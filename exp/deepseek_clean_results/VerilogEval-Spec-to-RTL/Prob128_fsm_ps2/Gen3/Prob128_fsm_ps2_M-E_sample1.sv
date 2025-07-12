module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // 3-byte shift register
    reg [7:0] byte_reg [2:0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 3; i = i + 1)
                byte_reg[i] <= 8'b0;
        end else begin
            // Shift in new byte
            byte_reg[2] <= byte_reg[1];
            byte_reg[1] <= byte_reg[0];
            byte_reg[0] <= in;
        end
    end

    // Combinational message detection
    assign done = (byte_reg[2][3] == 1'b1) && 
                  (byte_reg[1] !== 8'bx) && 
                  (byte_reg[0] !== 8'bx);

endmodule