module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment for three-input OR to optimize PPA
    assign out = a | b | c;

endmodule