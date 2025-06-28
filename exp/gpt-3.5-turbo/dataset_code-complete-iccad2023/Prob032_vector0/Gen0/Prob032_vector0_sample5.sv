module TopModule (
  input [2:0] vec,
  output [2:0] outv,
  output o2,
  output o1,
  output o0
);

  wire w0, w1, w2;
  
  assign {o2, o1, o0} = vec;
  assign outv = vec;

endmodule