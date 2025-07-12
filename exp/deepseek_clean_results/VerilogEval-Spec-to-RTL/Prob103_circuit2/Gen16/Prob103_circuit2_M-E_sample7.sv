module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    assign q = ~(ab_xor ^ cd_xor);
endmodule