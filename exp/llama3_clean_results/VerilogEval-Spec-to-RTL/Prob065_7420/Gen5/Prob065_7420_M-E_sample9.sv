module NAND2(
    input  a,
    input  b,
    output y
);

assign y = ~(a & b);

endmodule

module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

NAND2 nand1a(
   .a(p1a),
   .b(p1b),
   .y(nand1a_y)
);

NAND2 nand1b(
   .a(p1c),
   .b(p1d),
   .y(nand1b_y)
);

NAND2 nand1out(
   .a(nand1a_y),
   .b(nand1b_y),
   .y(p1y)
);

NAND2 nand2a(
   .a(p2a),
   .b(p2b),
   .y(nand2a_y)
);

NAND2 nand2b(
   .a(p2c),
   .b(p2d),
   .y(nand2b_y)
);

NAND2 nand2out(
   .a(nand2a_y),
   .b(nand2b_y),
   .y(p2y)
);

wire nand1a_y;
wire nand1b_y;
wire nand2a_y;
wire nand2b_y;

endmodule