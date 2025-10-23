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

    // First layer: two AND operations using assign statements
    assign and1_out = a & b;
    assign and2_out = c & d;

    // Second layer: OR operation combining the two AND results
    assign out = and1_out | and2_out;

    // Inverted output of out
    assign out_n = ~out;

endmodule