module TopModule (
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, used here as selector
    output out
);

wire term1, term2, nb, na, nc, nd;

assign nb = ~b;
assign na = a;
assign nc = c;
assign nd = d;

// term1 corresponds to (~c & ~d & a & ~b)
assign term1 = (~nc) & (~nd) & na & nb;

// term2 corresponds to (c & (a | b))
assign term2 = nc & (a | b);

// final output
assign out = term1 | term2;

endmodule