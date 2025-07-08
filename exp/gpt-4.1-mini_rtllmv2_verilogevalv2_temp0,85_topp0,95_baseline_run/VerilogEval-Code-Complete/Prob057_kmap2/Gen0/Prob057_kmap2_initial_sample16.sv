module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);
  assign out = 
    (~b & ~c) |
    (~a & ~d & (b | c)) |
    (a & c & d) |
    (~a & b & c & d);
endmodule