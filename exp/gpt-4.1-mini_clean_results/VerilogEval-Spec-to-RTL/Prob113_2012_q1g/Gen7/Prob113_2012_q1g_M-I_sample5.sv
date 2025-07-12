module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];

// f = (x2 & x3) | (~x1 & ~x3)
assign f = (x2 & x3) | (~x1 & ~x3);

endmodule