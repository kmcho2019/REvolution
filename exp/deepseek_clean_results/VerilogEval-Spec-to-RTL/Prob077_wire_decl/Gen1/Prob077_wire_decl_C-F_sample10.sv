module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: AND operations
    wire and_ab = a & b;
    wire and_cd = c & d;

    // Second layer: OR and inversion
    assign out = and_ab | and_cd;
    assign out_n = ~out;

endmodule