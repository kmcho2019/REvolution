module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor;
    wire abc_xor;
    wire abcd_xor;

    assign ab_xor = a ^ b;
    assign abc_xor = ab_xor ^ c;
    assign abcd_xor = abc_xor ^ d;
    assign q = ~abcd_xor;  // Even parity: invert the XOR of all inputs

endmodule