module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Optimized minimal sum-of-products from Karnaugh map analysis:
assign f = 
      x2
    | (~x2 & ~x3 & ~x1)
    | ( x3 & x2 & ~x0 & x1)
    | ( x2 & ~x3 &  x0 & ~x1);

endmodule