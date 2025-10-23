module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Output is the parity (XOR) of all inputs, matching the K-map pattern
    assign out = a ^ b ^ c ^ d;

endmodule