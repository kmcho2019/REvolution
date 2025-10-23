module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment implementing the logic function
    assign out = a | b | c;

endmodule