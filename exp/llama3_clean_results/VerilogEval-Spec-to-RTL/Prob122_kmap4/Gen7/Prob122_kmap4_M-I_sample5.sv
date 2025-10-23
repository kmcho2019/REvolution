module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    
// Intermediate signals for XOR operations
wire ab_xor = a ^ b;
wire cd_xor = c ^ d;

// Directly compute output based on XOR results
assign out = ab_xor ^ cd_xor;

endmodule