module TopModule (
  input [3:0] x,
  output logic f
);

  assign f = (x == 4'b0000 || x == 4'b0011 || x == 4'b0101 || x == 4'b0110 || x == 4'b1010 || x == 4'b1100 || x == 4'b1011);
  
endmodule