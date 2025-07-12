module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signal for XOR operation between a and b
wire ab_xor = (a ^ b);

// Intermediate signal for XOR operation between c and d
wire cd_xor = (c ^ d);

assign out = (ab_xor & cd_xor) | (~ab_xor & ~cd_xor);

endmodule