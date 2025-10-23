module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Intermediate variable to hold the XOR of a and b
wire ab_xor;
assign ab_xor = a ^ b;

// Intermediate variable to hold the XOR of (a^b) and c
wire abc_xor;
assign abc_xor = ab_xor ^ c;

// Final output q is the inverse of the XOR of all input bits
assign q = ~(abc_xor ^ d);

endmodule