module TopModule (
  input a,
  input b,
  input sel,
  output out
);
  
  assign out = (sel == 1) ? b : a;

endmodule