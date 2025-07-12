module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab_xor;
wire cd_xor;
wire parity;

assign ab_xor = a ^ b;
assign cd_xor = c ^ d;
assign parity = ab_xor ^ cd_xor;

// q is 1 for even parity, so invert the parity result
assign q = ~parity;

endmodule