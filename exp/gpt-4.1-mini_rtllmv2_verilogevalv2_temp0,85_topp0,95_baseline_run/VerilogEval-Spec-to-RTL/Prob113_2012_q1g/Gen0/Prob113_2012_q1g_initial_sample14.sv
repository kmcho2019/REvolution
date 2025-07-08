module TopModule (
    input [3:0] x,
    output reg f
);
    // According to the Karnaugh map:
    // rows: x[2] x[3]
    // cols: x[0] x[1]
    // index = {x[2], x[3], x[0], x[1]}
    always @(*) begin
        case ({x[2], x[3], x[0], x[1]})
            4'b0000: f = 1; // row 00 col 00 = 1
            4'b0001: f = 0; // row 00 col 01 = 0
            4'b0011: f = 0; // row 00 col 11 = 0
            4'b0010: f = 1; // row 00 col 10 = 1

            4'b0100: f = 0; // row 01 col 00 = 0
            4'b0101: f = 0; // row 01 col 01 = 0
            4'b0111: f = 0; // row 01 col 11 = 0
            4'b0110: f = 0; // row 01 col 10 = 0

            4'b1100: f = 1; // row 11 col 00 = 1
            4'b1101: f = 1; // row 11 col 01 = 1
            4'b1111: f = 1; // row 11 col 11 = 1
            4'b1110: f = 0; // row 11 col 10 = 0

            4'b1000: f = 1; // row 10 col 00 = 1
            4'b1001: f = 1; // row 10 col 01 = 1
            4'b1011: f = 0; // row 10 col 11 = 0
            4'b1010: f = 1; // row 10 col 10 = 1

            default: f = 0;
        endcase
    end
endmodule