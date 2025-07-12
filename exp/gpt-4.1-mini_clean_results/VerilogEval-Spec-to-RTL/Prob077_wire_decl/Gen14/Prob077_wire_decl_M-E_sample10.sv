module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for outputs of the AND gates
    wire and_out1;
    wire and_out2;

    // First layer: two AND gates
    and (and_out1, a, b);
    and (and_out2, c, d);

    // Second layer: OR gate combining the AND outputs
    or (out, and_out1, and_out2);

    // Inverted output via NOT gate primitive driven by 'out'
    not (out_n, out);

endmodule