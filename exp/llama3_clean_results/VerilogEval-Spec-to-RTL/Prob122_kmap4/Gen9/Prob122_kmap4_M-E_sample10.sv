module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Generate selection signal for multiplexer
wire sel = (c == d);

// Compute XOR of 'a' and 'b'
wire ab_xor = a ^ b;

// Compute inverse of XOR of 'a' and 'b'
wire ab_xor_inv = ~(a ^ b);

// Use multiplexer to select between XOR and its inverse
assign out = sel? ab_xor : ab_xor_inv;

endmodule