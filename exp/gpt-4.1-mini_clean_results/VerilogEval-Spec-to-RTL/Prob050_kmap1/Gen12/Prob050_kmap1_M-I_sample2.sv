module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment implementing the OR function
    assign out = a | b | c;

endmodule