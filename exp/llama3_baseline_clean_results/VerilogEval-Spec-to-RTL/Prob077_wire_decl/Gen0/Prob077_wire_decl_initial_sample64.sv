module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

wire and1;
wire and2;

// First layer: AND gates
and and_a_b(and1, a, b);
and and_c_d(and2, c, d);

// Second layer: OR gate and NOT gate
or or_and1_and2(out, and1, and2);
not not_out(out_n, out);

endmodule