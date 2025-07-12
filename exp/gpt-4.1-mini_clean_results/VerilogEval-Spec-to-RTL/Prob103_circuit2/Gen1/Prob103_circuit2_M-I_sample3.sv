module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire ab_xor;
    wire cd_xor;
    wire xor_out;

    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign xor_out = ab_xor ^ cd_xor;
    assign q = ~xor_out;
endmodule