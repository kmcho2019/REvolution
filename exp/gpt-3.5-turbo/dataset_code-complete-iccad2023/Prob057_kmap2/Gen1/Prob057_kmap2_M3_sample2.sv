module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);
  
assign out = a & c | b & c | a & b & ~d | c & ~a & d;

endmodule