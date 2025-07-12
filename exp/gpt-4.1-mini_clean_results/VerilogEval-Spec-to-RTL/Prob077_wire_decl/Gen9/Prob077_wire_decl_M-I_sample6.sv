module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Direct continuous assignment for AND-OR logic
    assign out = (a & b) | (c & d);

    // Inverted output as continuous assignment
    assign out_n = ~out;

endmodule