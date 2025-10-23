module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment for minimal logic and area
    assign out = a | b | c;

endmodule