module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Directly assign out to the 3-input OR of a, b, and c
    assign out = a | b | c;

endmodule