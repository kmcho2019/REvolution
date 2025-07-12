module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement f = (~x3 & x2) | (x3 & x1) using only NAND gates
    wire nand1_out, nand2_out, nand3_out;
    
    // First term: ~x3 & x2 = NAND(NAND(x3,x3), NAND(x2,x2))
    nand(nand1_out, x3, x3);  // Inverter
    nand(nand2_out, x2, x2);  // Buffer (for symmetry)
    nand(nand3_out, nand1_out, nand2_out);  // AND of ~x3 and x2
    
    // Second term: x3 & x1 = NAND(NAND(x3,x1), NAND(x3,x1))
    wire nand4_out;
    nand(nand4_out, x3, x1);
    
    // Final OR operation: NAND(NAND(term1,term1), NAND(term2,term2))
    wire nand5_out, nand6_out;
    nand(nand5_out, nand3_out, nand3_out);  // Buffer term1
    nand(nand6_out, nand4_out, nand4_out);  // Buffer term2
    nand(f, nand5_out, nand6_out);          // OR operation
endmodule