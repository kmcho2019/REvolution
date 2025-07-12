module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct OR of inputs; output is 1 for any input except when all zero
    assign out = a | b | c;

endmodule