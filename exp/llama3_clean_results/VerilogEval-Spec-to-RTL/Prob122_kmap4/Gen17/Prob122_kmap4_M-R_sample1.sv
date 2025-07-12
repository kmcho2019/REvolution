module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_xor; // Intermediate variable for XOR of a and b
    wire cd_xor; // Intermediate variable for XOR of c and d

    // Compute XOR of a and b
    assign ab_xor = a ^ b;
    
    // Compute XOR of c and d
    assign cd_xor = c ^ d;
    
    // Final output is the XOR of the two intermediate results
    assign out = ab_xor ^ cd_xor;

endmodule