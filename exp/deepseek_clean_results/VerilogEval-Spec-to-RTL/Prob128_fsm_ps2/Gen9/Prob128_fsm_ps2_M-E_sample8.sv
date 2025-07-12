module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [7:0] byte_shift [0:2];  // 3-byte shift register
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 3; i = i + 1)
                byte_shift[i] <= 8'b0;
        end else begin
            // Shift in new byte
            byte_shift[2] <= byte_shift[1];
            byte_shift[1] <= byte_shift[0];
            byte_shift[0] <= in;
        end
    end

    // Combinational done signal when we have a complete message
    assign done = (byte_shift[2][3] == 1'b1) && 
                  (byte_shift[1] !== 8'bx) && 
                  (byte_shift[0] !== 8'bx);

endmodule