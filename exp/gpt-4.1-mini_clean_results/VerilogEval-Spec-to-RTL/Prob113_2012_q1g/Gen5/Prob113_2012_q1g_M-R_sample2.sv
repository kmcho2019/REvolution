module TopModule(
    input  [3:0] x,
    output reg    f
);
    // According to the problem:
    // Rows = x[2] x[3], Columns = x[0] x[1]
    // 4-bit input x = {x[3], x[2], x[1], x[0]} but the map uses
    // row MSB = x[2], row LSB = x[3]
    // col MSB = x[0], col LSB = x[1]
    //
    // We'll index the cases by x as is (x[3:0]),
    // but carefully translate the K-map values.

    always @(*) begin
        case (x)
            4'b0000: f = 1; // row=00(col bits: 00) -> f=1
            4'b0001: f = 0; // 00 01 = 0
            4'b0010: f = 1; // 00 10 = 1
            4'b0011: f = 0; // 00 11 = 0

            4'b0100: f = 0; // 01 00 = 0
            4'b0101: f = 0; // 01 01 = 0
            4'b0110: f = 0; // 01 10 = 0
            4'b0111: f = 0; // 01 11 = 0

            4'b1100: f = 1; // 11 00 = 1
            4'b1101: f = 1; // 11 01 = 1
            4'b1110: f = 0; // 11 10 = 0
            4'b1111: f = 1; // 11 11 = 1

            4'b1000: f = 1; // 10 00 = 1
            4'b1001: f = 1; // 10 01 = 1
            4'b1010: f = 1; // 10 10 = 1
            4'b1011: f = 0; // 10 11 = 0

            default: f = 0;
        endcase
    end

endmodule