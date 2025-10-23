module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate XOR pairs used to compute output efficiently:
    // ab_xor = a XOR b
    // cd_xor = c XOR d
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;

    // Output is parity of all four inputs as specified by the Karnaugh map.
    // Computed as XOR of ab_xor and cd_xor for minimal gate depth and clarity.
    assign out = ab_xor ^ cd_xor;

endmodule