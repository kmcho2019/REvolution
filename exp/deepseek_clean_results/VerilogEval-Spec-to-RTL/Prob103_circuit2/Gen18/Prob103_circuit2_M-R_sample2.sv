module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_xor, cd_xor;
    wire combined_xor;
    
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign combined_xor = ab_xor ^ cd_xor;
    assign q = ~combined_xor;

endmodule