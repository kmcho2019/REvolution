module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire ab_xor;
    wire cd_xor;

    // XOR pairs of inputs
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    // Final output is XNOR of the two XOR results (even parity)
    assign q = ab_xor ~^ cd_xor;

endmodule