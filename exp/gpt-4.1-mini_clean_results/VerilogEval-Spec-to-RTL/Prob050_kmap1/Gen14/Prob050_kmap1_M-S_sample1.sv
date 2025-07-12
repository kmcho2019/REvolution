module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment for minimal, clear implementation
    assign out = a | b | c;

endmodule