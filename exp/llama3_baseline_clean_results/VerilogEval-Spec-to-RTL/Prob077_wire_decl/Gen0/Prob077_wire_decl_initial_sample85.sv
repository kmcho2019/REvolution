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
    assign and_out1 = a & b;
    assign and_out2 = c & d;

    // Instantiate OR gate
    assign out = and_out1 | and_out2;

    // Instantiate NOT gate (inverted output)
    assign out_n = ~out;

endmodule