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

    // First layer: two AND gates implemented with continuous assign
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Second layer: OR gate implemented with continuous assign
    assign out = and_ab | and_cd;

    // Inverted output implemented explicitly with primitive gate
    not (out_n, out);

endmodule