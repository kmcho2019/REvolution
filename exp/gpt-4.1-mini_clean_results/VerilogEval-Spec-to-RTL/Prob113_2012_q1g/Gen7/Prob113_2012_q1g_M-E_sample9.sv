module TopModule(
    input  [3:0] x,
    output       f
);

wire x0_n = ~x[0];
wire x1_n = ~x[1];
wire x2_n = ~x[2];
wire x3_n = ~x[3];

// f = (x[2] & x[3]) | (x[2] & ~x[0]) | (~x[2] & ~x[3] & ~x[0]) | (x[2] & ~x[3] & x[0] & ~x[1])
assign f = (x[2] & x[3])
         | (x[2] & x0_n)
         | (x2_n & x3_n & x0_n)
         | (x[2] & x3_n & x[0] & x1_n);

endmodule