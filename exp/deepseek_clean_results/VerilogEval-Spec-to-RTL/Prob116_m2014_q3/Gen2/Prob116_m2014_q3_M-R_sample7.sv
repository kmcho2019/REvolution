module TopModule(
    input [3:0] x,
    output f
);
    // x[3]x[2] are the row bits, x[1]x[0] are the column bits
    assign f = ((x[3] & x[2]) & ~x[1]) |        // 11xx when x[1]x[0] is 00 or 01
               ((x[3] & ~x[2]) & ~x[1]) |       // 10xx when x[1]x[0] is 00 or 01
               ((~x[3] & x[2]) & (x[1] & x[0])); // 01xx when x[1]x[0] is 11
endmodule