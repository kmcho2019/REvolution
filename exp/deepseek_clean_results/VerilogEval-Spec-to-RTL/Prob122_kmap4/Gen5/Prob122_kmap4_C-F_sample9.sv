module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate XOR results for better readability
    wire ab_xor = a ^ b;  // Row pattern (alternating every row)
    wire cd_xor = c ^ d;  // Column pattern (alternating every column)
    
    // Final output combines both patterns
    assign out = ab_xor ^ cd_xor;  // Checkerboard pattern
endmodule