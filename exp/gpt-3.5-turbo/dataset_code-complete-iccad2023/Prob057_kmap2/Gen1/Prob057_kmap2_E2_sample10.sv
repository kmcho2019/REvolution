module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire term1, term2, term3, term4;

assign term1 = ~a & ~b & c | ~a & b & c | a & b & c | a & b & ~d;
assign term2 = a & ~b & d | b & c & ~d | a & c & d;
assign term3 = a & b & d;
assign term4 = a & ~c & ~d;

assign out = term1 | term2 | term3 | term4;

endmodule