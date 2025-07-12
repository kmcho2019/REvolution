module TopModule(
    input  [3:0] x,
    output       f
);

    // f = (x[3] & ~x[1]) | (~x[3] & x[0] & x[1] & x[2])

    assign f = (x[3] & ~x[1]) | (~x[3] & x[0] & x[1] & x[2]);

endmodule