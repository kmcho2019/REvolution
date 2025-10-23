module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Calculate the XOR of a and b
wire ab_xor;
assign ab_xor = (a & ~b) | (~a & b);

// Calculate the XOR of ab_xor and c
wire abc_xor;
assign abc_xor = (ab_xor & ~c) | (~ab_xor & c);

// Calculate the XOR of abc_xor and d
wire abcd_xor;
assign abcd_xor = (abc_xor & ~d) | (~abc_xor & d);

// Calculate the output q as the inverse of abcd_xor
assign q = ~abcd_xor;

endmodule