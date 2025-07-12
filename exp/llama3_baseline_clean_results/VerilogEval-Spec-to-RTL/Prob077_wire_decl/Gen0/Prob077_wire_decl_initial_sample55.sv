module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out1;
wire and_out2;

// First layer: AND gates
and gate1(a, b, and_out1);
and gate2(c, d, and_out2);

// Second layer: OR gate
or gate3(and_out1, and_out2, out);

// Inverted output
not gate4(out, out_n);

endmodule