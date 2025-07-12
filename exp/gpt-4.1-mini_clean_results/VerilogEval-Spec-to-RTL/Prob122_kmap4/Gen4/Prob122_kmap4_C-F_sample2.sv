module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate XOR signals to improve modularity and clarity:
    // ab_xor = a XOR b
    // cd_xor = c XOR d
    // Output is XOR of these two signals,
    // which equals the parity of all four inputs and matches the Karnaugh map.
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;

    assign out = ab_xor ^ cd_xor;

endmodule