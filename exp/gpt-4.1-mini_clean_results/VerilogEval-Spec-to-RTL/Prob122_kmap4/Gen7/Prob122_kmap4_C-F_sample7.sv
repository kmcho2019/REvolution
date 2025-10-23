module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute XOR of a and b
    wire ab_xor = a ^ b;
    // Compute XOR of c and d
    wire cd_xor = c ^ d;

    // Final output is XOR of the two intermediate XORs, 
    // representing parity of all four inputs.
    // This exactly matches the Karnaugh map and is minimal logic.
    assign out = ab_xor ^ cd_xor;

endmodule