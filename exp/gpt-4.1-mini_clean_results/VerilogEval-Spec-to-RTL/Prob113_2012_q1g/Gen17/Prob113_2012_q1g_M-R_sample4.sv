module TopModule(
    input  [3:0] x,
    output       f
);

    assign f = (~x[3] & ~x[2] & (~x[1] ^ ~x[0]))  // row 00: f=1 when x[0]x[1] = 00 or 10
            | (x[3] & x[2] & (~x[1] | x[0]))       // row 11: f=1 except for 10
            | (x[3] & ~x[2] & (~x[1] | ~x[0]));   // row 10: f=1 except for 11

endmodule