module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

// Implementing the simplified function: f = !a*!b*c + a*!b*d + abcd + !ac!d

wire term1, term2, term3, term4;

assign term1 = ~a & ~b & c;
assign term2 = a & ~b & d;
assign term3 = a & b & c & d;
assign term4 = ~a & c & ~d;

assign out = term1 | term2 | term3 | term4;

endmodule