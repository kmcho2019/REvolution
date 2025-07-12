module TopModule(
    input  [3:0] x,
    output       f
);

// Direct assignment without intermediate wires for simplicity
assign f = (~x[3] & ~x[1])
        | (~x[3] & x[2] & x[1] & ~x[0])
        | (x[3] & x[2] & (~x[0] | (x[1] & x[0])));

endmodule