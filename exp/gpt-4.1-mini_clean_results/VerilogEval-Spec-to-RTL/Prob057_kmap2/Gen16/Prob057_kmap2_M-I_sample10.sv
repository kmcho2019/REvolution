module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire not_a = ~a;
wire not_b = ~b;
wire not_c = ~c;
wire not_d = ~d;

// Shared common sub-expressions
wire term1 = not_c & not_d & (not_a | not_b);    // Covers cd=00 and ab=00,01,10
wire term2 = not_c & d & not_b;                  // Covers cd=01 and ab=00,10
wire term3 = c & not_d & not_a;                   // Covers cd=10 and ab=00,01
wire term4 = c & d & (a | b);                     // Covers cd=11 and ab=01,10,11

assign out = term1 | term2 | term3 | term4;

endmodule