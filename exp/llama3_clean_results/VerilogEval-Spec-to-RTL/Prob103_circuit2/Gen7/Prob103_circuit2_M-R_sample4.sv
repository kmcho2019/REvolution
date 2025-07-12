module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Define intermediate signals to calculate the XOR of pairs of inputs
wire ab_xor;
assign ab_xor = a ^ b;

wire cd_xor;
assign cd_xor = c ^ d;

// Calculate the final output q as the inverse of the XOR of the intermediate signals
assign q = ~(ab_xor ^ cd_xor);

endmodule