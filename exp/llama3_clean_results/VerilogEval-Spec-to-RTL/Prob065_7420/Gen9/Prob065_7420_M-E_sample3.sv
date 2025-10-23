module MUX_NAND4(
    input  [3:0] inputs,
    output reg y
);

assign y = ~(inputs[0] & inputs[1] & inputs[2] & inputs[3]);

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

MUX_NAND4 nand1(
  .inputs({p1a, p1b, p1c, p1d}),
  .y(p1y)
);

MUX_NAND4 nand2(
  .inputs({p2a, p2b, p2c, p2d}),
  .y(p2y)
);

endmodule