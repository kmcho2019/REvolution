module TopModule (
  input a,
  input b,
  input c,
  output out
);

  wire check;
  
  assign check = ~(a & b & c);
  
  assign out = check;

endmodule