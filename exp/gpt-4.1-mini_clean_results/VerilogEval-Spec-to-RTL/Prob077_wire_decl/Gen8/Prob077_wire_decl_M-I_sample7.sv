module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires connecting gate outputs
    wire and_ab;
    wire and_cd;

    // Use Verilog built-in gate primitives with intermediate wires
    and (and_ab, a, b);
    and (and_cd, c, d);

    or  (out, and_ab, and_cd);
    not (out_n, out);

endmodule