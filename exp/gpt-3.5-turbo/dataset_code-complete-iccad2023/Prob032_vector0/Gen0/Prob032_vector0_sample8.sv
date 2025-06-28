module TopModule (
  input [2:0] vec,
  output [2:0] outv,
  output o2,
  output o1,
  output o0
);
  
  assign {o2, o1, o0} = vec; // Assign each output to the respective bit of the input vector
  assign outv = vec; // Output the input vector directly

endmodule