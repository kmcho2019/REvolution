module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: two AND gates
    wire and1_out = a & b;
    wire and2_out = c & d;

    // Second layer: OR gate
    assign out = and1_out | and2_out;

    // Inverted output
    assign out_n = ~out;

endmodule