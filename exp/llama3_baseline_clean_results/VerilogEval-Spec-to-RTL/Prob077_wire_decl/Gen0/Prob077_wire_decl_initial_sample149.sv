module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

// Declare intermediate wires
wire and_out1;
wire and_out2;

// First layer: AND gates
and gate1(and_out1, a, b);
and gate2(and_out2, c, d);

// Second layer: OR gate
or gate3(out, and_out1, and_out2);

// Inverted output
not gate4(out_n, out);

endmodule