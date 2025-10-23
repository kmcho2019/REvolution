module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Declare intermediate wires first
    wire and_ab;
    wire and_cd;

    // First layer: AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Second layer: OR and NOT
    assign out = and_ab | and_cd;
    assign out_n = ~out;

endmodule