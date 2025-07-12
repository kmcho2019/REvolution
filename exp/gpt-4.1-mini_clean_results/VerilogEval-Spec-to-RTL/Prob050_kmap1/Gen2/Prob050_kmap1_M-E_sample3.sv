module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

wire na, nb, nc;
wire and_nabc;

// Invert inputs
not u_not_a(na, a);
not u_not_b(nb, b);
not u_not_c(nc, c);

// AND of inverted inputs
and u_and(and_nabc, na, nb, nc);

// Output is negation of AND result
not u_not_out(out, and_nabc);

endmodule