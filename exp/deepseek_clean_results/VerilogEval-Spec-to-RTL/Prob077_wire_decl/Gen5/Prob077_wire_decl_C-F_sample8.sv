module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Intermediate wires for better readability
    wire and_ab = a & b;
    wire and_cd = c & d;

    // Combined OR operation and inversion
    assign out = and_ab | and_cd;
    assign out_n = ~out;

endmodule