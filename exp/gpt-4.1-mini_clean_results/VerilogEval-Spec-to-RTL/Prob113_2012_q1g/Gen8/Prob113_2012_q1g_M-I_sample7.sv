module TopModule(
    input  [3:0] x,
    output       f
);

// Simplified expression using Boolean algebra:
// f = (~x3 & ~x1)
//   | (~x3 & x2 & x1 & ~x0)
//   | (x3 & x2 & (~x0 | x1));

assign f = (~x[3] & ~x[1])
        | (~x[3] & x[2] & x[1] & ~x[0])
        | ( x[3] & x[2] & (~x[0] | x[1]) );

endmodule