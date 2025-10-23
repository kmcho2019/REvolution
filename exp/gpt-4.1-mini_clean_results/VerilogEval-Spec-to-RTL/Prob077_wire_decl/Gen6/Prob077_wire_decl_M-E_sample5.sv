module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire w_and1, w_and2;

// First layer: two AND gates
and and_gate1(w_and1, a, b);
and and_gate2(w_and2, c, d);

// Second layer: one OR gate
or  or_gate(out, w_and1, w_and2);

// Inverted output using NOT gate primitive
not not_gate(out_n, out);

endmodule