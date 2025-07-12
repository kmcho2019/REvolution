module TopModule(
    input  [3:0] x,
    output       f
);

// Directly accessing bits and combining terms differently
assign f = (~x[3] & ~x[1])
        | (~x[3] & x[2] & x[1] & ~x[0])
        | (x[3] & x[2] & (~x[0] | (x[1] & x[0])));

endmodule