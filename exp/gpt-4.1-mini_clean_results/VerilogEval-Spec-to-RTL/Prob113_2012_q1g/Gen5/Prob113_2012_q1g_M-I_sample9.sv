module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Optimized expression with factoring common terms:
assign f = (~x3 & ~x1)
        | (~x3 & x2 & x1 & ~x0)
        | (x3 & x2 & (~x0 | (x1 & x0)));

endmodule