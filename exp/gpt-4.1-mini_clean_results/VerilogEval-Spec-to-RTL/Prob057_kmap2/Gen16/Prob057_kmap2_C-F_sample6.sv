module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Complement inputs
wire not_a = ~a;
wire not_b = ~b;
wire not_c = ~c;
wire not_d = ~d;

// Common sub-expressions
wire a_or_b       = a | b;
wire not_a_or_not_b = not_a | not_b;

// Product terms
wire term1 = not_c & not_d & not_a_or_not_b;  // (~c & ~d & (~a | ~b))
wire term2 = not_c & d     & not_b;            // (~c & d & ~b)
wire term3 = c     & not_d & not_a;            // (c & ~d & ~a)
wire term4 = c     & d     & a_or_b;           // (c & d & (a | b))

// Final output
assign out = term1 | term2 | term3 | term4;

endmodule