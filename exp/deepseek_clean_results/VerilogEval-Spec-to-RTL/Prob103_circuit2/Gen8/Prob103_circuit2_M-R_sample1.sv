module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_xor, cd_xor;
    wire intermediate;
    
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign intermediate = ab_xor ^ cd_xor;
    assign q = ~intermediate;

endmodule