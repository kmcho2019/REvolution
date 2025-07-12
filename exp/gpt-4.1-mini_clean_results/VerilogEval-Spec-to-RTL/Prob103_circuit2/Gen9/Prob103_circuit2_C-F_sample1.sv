module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab_xor, cd_xor, all_xor;

assign ab_xor = a ^ b;
assign cd_xor = c ^ d;
assign all_xor = ab_xor ^ cd_xor;

// Even parity = complement of odd parity (XOR)
assign q = ~all_xor;

endmodule