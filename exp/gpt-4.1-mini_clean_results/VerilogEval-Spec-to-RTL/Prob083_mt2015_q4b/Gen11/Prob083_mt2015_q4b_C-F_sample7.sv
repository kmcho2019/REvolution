module TopModule(input x, input y, output z);
  // Output z is high when inputs x and y are equal (XNOR function).
  // Equivalent to: (x & y) | (~x & ~y).
  assign z = x ~^ y;
endmodule