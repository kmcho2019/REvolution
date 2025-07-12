module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Directly assign q as the OR of b and c
    assign q = b | c;
endmodule