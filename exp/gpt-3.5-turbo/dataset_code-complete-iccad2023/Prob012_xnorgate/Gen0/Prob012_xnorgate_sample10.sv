module TopModule (
  input a,
  input b,
  output out
);
  
  assign out = a xnor b;
  
endmodule