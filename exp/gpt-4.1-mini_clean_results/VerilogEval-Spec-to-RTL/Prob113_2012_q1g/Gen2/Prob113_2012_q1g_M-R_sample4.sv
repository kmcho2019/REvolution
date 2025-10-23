module TopModule(
    input  [3:0] x,
    output       f
);

// According to the Karnaugh map:
// f=1 for these minterms (decimal):
// Row x[3]x[2], Column x[1]x[0]:
// 00 00 -> 0b0000 = 0
// 00 10 -> 0b0010 = 2
// 11 00 -> 0b1100 = 12
// 11 01 -> 0b1101 = 13
// 11 11 -> 0b1111 = 15
// 10 00 -> 0b1000 = 8
// 10 01 -> 0b1001 = 9
// 10 10 -> 0b1010 = 10

assign f = (x == 4'd0)  ||
           (x == 4'd2)  ||
           (x == 4'd8)  ||
           (x == 4'd9)  ||
           (x == 4'd10) ||
           (x == 4'd12) ||
           (x == 4'd13) ||
           (x == 4'd15);

endmodule