module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Balanced XOR tree implementing 4-input parity:
    // Output is 1 if an odd number of inputs are 1, per the Karnaugh map
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;

endmodule