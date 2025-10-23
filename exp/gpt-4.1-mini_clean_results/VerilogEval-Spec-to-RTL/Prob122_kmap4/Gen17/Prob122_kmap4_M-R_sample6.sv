module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Direct XOR chain without intermediate wires
    assign out = a ^ b ^ c ^ d;

endmodule