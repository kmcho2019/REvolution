module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: AND gates
    wire and1_out = a & b;
    wire and2_out = c & d;

    // Second layer: OR gate and NOT gate
    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule