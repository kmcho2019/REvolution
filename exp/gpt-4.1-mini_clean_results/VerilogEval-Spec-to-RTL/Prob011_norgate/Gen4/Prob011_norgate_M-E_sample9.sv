module TopModule(input a, input b, output out);
  wire na, nb;
  nand (na, a, a); // na = ~a
  nand (nb, b, b); // nb = ~b
  nand (out, na, nb); // out = ~(~a & ~b) = a | b, then inverted by NAND with inverted inputs -> NOR
endmodule