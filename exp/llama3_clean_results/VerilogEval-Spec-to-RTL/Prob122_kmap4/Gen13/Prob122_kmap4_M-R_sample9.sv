module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    
// Intermediate signals for XOR of a and b, and XOR of c and d
wire ab_xor;
wire cd_xor;

// Compute XOR of a and b
assign ab_xor = a ^ b;

// Compute XOR of c and d
assign cd_xor = c ^ d;

// Compute final output as XOR of ab_xor and cd_xor
assign out = ab_xor ^ cd_xor;

endmodule