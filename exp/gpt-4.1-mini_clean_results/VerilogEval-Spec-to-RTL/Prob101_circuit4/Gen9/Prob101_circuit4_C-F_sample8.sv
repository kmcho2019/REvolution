module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Direct combinational assignment for minimal, clear, and efficient OR of b and c
    assign q = b | c;
endmodule