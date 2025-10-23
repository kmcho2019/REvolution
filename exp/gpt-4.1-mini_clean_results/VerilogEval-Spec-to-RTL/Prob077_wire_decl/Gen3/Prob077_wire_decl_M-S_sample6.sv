module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // First layer: two AND gates feeding OR gate inputs directly
    and and1(w1, a, b);
    and and2(w2, c, d);

    or or1(out, w1, w2);

    // Inverted output of out
    not not1(out_n, out);

endmodule