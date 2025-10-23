module TopModule(
  input a,
  input b,
  input c,
  input d,
  output out
);

assign out = (b & ~a & ~c & ~d) | 
             (~a & ~b & ~c & d) | 
             (~a & ~b & c & ~d) | 
             (a & b & c & ~d) | 
             (~a & b & c & d) | 
             (a & ~b & c & d);

endmodule