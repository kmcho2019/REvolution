module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Declare intermediate wires
wire and_out1;
wire and_out2;

// Instantiate AND gates
and and1(a, b, and_out1);
and and2(c, d, and_out2);

// Instantiate OR gate
or or1(and_out1, and_out2, out);

// Instantiate NOT gate for inverted output
not not1(out, out_n);

endmodule