module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Intermediate XOR results
    wire ab_xor;  // XOR of a and b
    wire cd_xor;  // XOR of c and d
    wire abcd_xor; // Final XOR of all inputs

    // Calculate parity in stages
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign abcd_xor = ab_xor ^ cd_xor;
    
    // Output is 1 when even number of inputs are 1 (parity check)
    assign q = ~abcd_xor;
endmodule