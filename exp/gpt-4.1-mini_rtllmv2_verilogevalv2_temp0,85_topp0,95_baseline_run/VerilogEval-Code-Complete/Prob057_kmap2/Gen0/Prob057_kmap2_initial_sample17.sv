module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);
  assign out = (~c & ~a) | (c & d & b) | (d & a & ~b) | (c & ~d & ~a) | (~d & ~a & b);
endmodule