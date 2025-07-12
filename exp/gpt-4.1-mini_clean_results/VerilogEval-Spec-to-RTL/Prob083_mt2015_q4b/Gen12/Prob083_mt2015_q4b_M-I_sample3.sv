module TopModule(input x, input y, output wire z);
  // z is high when inputs x and y are equal.
  // Logical equivalent: z = x XNOR y = (x & y) | (~x & ~y)
  assign z = x ~^ y;
endmodule