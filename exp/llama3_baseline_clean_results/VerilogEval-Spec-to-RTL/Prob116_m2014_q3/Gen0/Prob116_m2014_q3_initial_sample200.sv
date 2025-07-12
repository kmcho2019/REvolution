module TopModule(x, f);
  input [3:0] x; // Assuming x[3] is the most significant bit and x[0] is the least significant bit
  output f;

  assign f = (x[3] & x[2]) | (x[1] & x[0]) | (x[3] & ~x[2] & ~x[1] & x[0]);
endmodule