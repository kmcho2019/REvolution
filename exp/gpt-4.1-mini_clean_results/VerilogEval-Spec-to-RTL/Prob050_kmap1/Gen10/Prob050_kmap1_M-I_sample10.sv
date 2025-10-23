module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Direct continuous assignment for OR of inputs
    assign out = a | b | c;
endmodule