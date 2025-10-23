module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate XOR results
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    
    // Final XOR combination
    assign out = ab_xor ^ cd_xor;
endmodule