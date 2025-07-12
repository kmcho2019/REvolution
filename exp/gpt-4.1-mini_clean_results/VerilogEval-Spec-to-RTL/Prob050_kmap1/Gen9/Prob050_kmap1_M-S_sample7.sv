module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Simplify to OR of inputs to match the K-map output
    assign out = a | b | c;

endmodule