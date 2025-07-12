module TopModule(
  input  a,
  input  b,
  input  c,
  input  d,
  output out_sop,
  output out_pos
);

// Minimum sum-of-products form for out_sop
assign out_sop = (b & c & d) | // 7
                 (~a & b & c & d) | // 7 (since 7 corresponds to 0111)
                 (a & b & c & d); // 15

// Minimum product-of-sums form for out_pos
assign out_pos = ~(~a & ~b & ~c & ~d) & // not 0
                 ~(~a & b & ~c & ~d) & // not 1
                 ~(~a & ~b & c & ~d) & // not 4
                 ~(~a & b & c & ~d) & // not 5
                 ~(~a & ~b & c & d) & // not 6
                 ~(a & ~b & ~c & ~d) & // not 8 (but this condition never occurs, so we can ignore it)
                 ~(~a & b & ~c & d) & // not 9
                 ~(~a & ~b & c & d) & // not 10
                 ~(a & b & ~c & ~d) & // not 12 (but this condition never occurs, so we can ignore it)
                 ~(~a & b & c & d); // not 13

endmodule