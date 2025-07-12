module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment for minimal area and power
    assign out = a | b | c;

endmodule