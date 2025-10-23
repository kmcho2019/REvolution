module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Direct XOR of all inputs implementing the K-map pattern
    assign out = a ^ b ^ c ^ d;

endmodule