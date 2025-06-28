module TopModule (
  input x3,
  input x2,
  input x1,
  output f
);
  
  assign f = ((x3 + x2 + x1) % 2 == 1) ? 1 : 0;

endmodule