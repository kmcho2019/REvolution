module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// XOR-based implementation
wire ab_xor = a ^ b;
wire cd_xor = c ^ d;
wire ab_xnor = ~(a ^ b);
wire cd_xnor = ~(c ^ d);

// Combine terms using the observed pattern
assign out = (ab_xor & cd_xnor) | (ab_xnor & cd_xor) | (a & b & c & d);

endmodule