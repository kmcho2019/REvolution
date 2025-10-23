module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Implement (a^b)^(c^d) using NAND gates only
    wire ab_xor, cd_xor;
    
    // XOR(a,b) = (a NAND (a NAND b)) NAND (b NAND (a NAND b))
    wire ab_nand, a_ab_nand, b_ab_nand;
    nand nand1(ab_nand, a, b);
    nand nand2(a_ab_nand, a, ab_nand);
    nand nand3(b_ab_nand, b, ab_nand);
    nand nand4(ab_xor, a_ab_nand, b_ab_nand);
    
    // XOR(c,d) = (c NAND (c NAND d)) NAND (d NAND (c NAND d))
    wire cd_nand, c_cd_nand, d_cd_nand;
    nand nand5(cd_nand, c, d);
    nand nand6(c_cd_nand, c, cd_nand);
    nand nand7(d_cd_nand, d, cd_nand);
    nand nand8(cd_xor, c_cd_nand, d_cd_nand);
    
    // Final XOR between ab_xor and cd_xor
    wire xor_nand, ab_xor_nand, cd_xor_nand;
    nand nand9(xor_nand, ab_xor, cd_xor);
    nand nand10(ab_xor_nand, ab_xor, xor_nand);
    nand nand11(cd_xor_nand, cd_xor, xor_nand);
    nand nand12(out, ab_xor_nand, cd_xor_nand);

endmodule