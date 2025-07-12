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

    // XOR pairs a and b
    assign ab_xor = a ^ b;

    // XOR pairs c and d
    assign cd_xor = c ^ d;

    // XOR of previous results to get overall odd parity
    assign parity = ab_xor ^ cd_xor;

    // Invert to get even parity output q
    assign q = ~parity;

endmodule