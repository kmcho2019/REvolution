module TopModule(
    input  [3:0] x,
    output       f
);

    // Expression for when x[2] and x[3] are both 0
    wire cond_00;
    assign cond_00 = (~x[0] & ~x[1]) | (x[0] & ~x[1]);

    // Expression for when x[2] and x[3] are both 1
    wire cond_11;
    assign cond_11 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);

    // Expression for when x[2] is 1 and x[3] is 0
    wire cond_10;
    assign cond_10 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]);

    // Combine the outputs of the expressions
    assign f = (~x[2] & ~x[3] & cond_00) | (x[2] & x[3] & cond_11) | (x[2] & ~x[3] & cond_10);

endmodule