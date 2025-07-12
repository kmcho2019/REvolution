module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
  // B implements XNOR of x and y based on the waveform.
  assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
  wire a1, a2, b1, b2;
  wire nand_out, nor_out;

  // Instantiate two A modules
  A A1(.x(x), .y(y), .z(a1));
  A A2(.x(x), .y(y), .z(a2));

  // Instantiate two B modules
  B B1(.x(x), .y(y), .z(b1));
  B B2(.x(x), .y(y), .z(b2));

  // NAND gate combining outputs of A1 and B1
  assign nand_out = ~(a1 & b1);

  // NOR gate combining outputs of A2 and B2
  assign nor_out = ~(a2 | b2);

  // Final XNOR of nand_out and nor_out produces z
  assign z = ~(nand_out ^ nor_out);
endmodule