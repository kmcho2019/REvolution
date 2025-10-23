module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Product terms from the minimized Karnaugh map expression:
// T1 = ~d & ~a
wire term1 = nd & na;

// T2 = ~c & ~b
wire term2 = nc & nb;

// T3 = c & d & (a | b)
wire a_or_b = a | b;
wire term3 = c & d & a_or_b;

// Final output is the OR of all three terms
assign out = term1 | term2 | term3;

endmodule