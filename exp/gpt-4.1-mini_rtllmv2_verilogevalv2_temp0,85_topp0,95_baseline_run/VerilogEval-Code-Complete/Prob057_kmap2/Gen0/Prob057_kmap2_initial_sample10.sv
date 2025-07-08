module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

  assign out = (~a & ~b) 
               | (a & ~b) 
               | (b & c & d) 
               | (b & ~c & ~d) 
               | (~a & b & ~c & ~d);

endmodule