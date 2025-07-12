module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Balanced XOR tree implemented with continuous assignments for clarity and minimal logic depth
    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;

    assign out = xor_ab ^ xor_cd;
endmodule