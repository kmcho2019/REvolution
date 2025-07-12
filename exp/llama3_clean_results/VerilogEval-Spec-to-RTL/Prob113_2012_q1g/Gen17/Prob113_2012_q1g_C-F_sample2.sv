module TopModule(
    input [3:0] x,
    output f
);

    // Direct implementation of conditions from Karnaugh map
    // with simplified logic expression using Boolean algebra rules
    assign f = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x[2] & (x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]) |
                       (~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1])));

endmodule