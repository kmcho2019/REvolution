module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Direct XOR of all inputs
    assign out = a ^ b ^ c ^ d;

endmodule