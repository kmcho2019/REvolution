module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and1_out;
    wire and2_out;

    // First layer: two AND gates implemented as continuous assignments
    assign and1_out = a & b;
    assign and2_out = c & d;

    // Second layer: OR gate implemented as continuous assignment
    assign out = and1_out | and2_out;

    // Inverted output generated using explicit NOT gate instance
    not not_gate (out_n, out);

endmodule