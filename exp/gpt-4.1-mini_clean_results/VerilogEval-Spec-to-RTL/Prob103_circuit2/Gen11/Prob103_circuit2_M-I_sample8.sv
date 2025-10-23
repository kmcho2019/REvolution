module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor;
    wire cd_xor;
    wire abcd_xor;

    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign abcd_xor = ab_xor ^ cd_xor;
    assign q = ~abcd_xor;  // Even parity output

endmodule