module TopModule (
  input [3:0] x,
  output logic f
);

assign f = (x != 4) & (x != 6) & (x != 5) & (x != 9);

endmodule