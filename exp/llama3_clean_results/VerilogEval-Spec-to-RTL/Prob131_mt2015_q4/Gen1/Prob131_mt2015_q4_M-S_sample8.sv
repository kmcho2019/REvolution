module topLevel(x, y, z);
  input x, y;
  output z;
  wire a1, b1, a2, b2;

  assign a1 = (x ^ y) & x;
  assign b1 = ~(x ^ y);
  assign a2 = (x ^ y) & x;
  assign b2 = ~(x ^ y);

  assign z = (a1 | b1) ^ (a2 & b2);
endmodule