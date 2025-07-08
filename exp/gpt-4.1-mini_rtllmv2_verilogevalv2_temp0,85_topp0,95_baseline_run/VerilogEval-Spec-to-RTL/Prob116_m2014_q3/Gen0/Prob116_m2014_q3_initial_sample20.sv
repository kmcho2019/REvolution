module TopModule(
    input  [4:1] x,
    output reg f
);

    always @(*) begin
        // Extract row and column indices from x
        // row = x[4]x[3]
        // col = x[1]x[2]
        case ({x[4], x[3], x[1], x[2]})
            // row=00, col=00 -> d (choose 0)
            4'b0000: f = 0;
            // row=00, col=01 -> 0
            4'b0001: f = 0;
            // row=00, col=11 -> d (choose 0)
            4'b0011: f = 0;
            // row=00, col=10 -> d (choose 0)
            4'b0010: f = 0;

            // row=01, col=00 -> 0
            4'b0100: f = 0;
            // row=01, col=01 -> d (choose 0)
            4'b0101: f = 0;
            // row=01, col=11 -> 1
            4'b0111: f = 1;
            // row=01, col=10 -> 0
            4'b0110: f = 0;

            // row=11, col=00 -> 1
            4'b1100: f = 1;
            // row=11, col=01 -> 1
            4'b1101: f = 1;
            // row=11, col=11 -> d (choose 0)
            4'b1111: f = 0;
            // row=11, col=10 -> d (choose 0)
            4'b1110: f = 0;

            // row=10, col=00 -> 1
            4'b1000: f = 1;
            // row=10, col=01 -> 1
            4'b1001: f = 1;
            // row=10, col=11 -> 0
            4'b1011: f = 0;
            // row=10, col=10 -> d (choose 0)
            4'b1010: f = 0;

            default: f = 0; // default case for safety
        endcase
    end

endmodule