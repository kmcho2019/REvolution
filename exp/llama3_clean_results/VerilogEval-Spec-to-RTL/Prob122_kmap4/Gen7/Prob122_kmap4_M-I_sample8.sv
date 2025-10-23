module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signal for XOR operation between a and b
wire ab_xor = a ^ b;

assign out = (ab_xor ^ (c ^ d));

endmodule