module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Optimized implementation using only 8 NAND gates
    wire n1, n2, n3, n4, n5, n6, n7, n8;
    
    // First XOR (a^b) using 3 NANDs
    nand g1(n1, a, b);
    nand g2(n2, a, n1);
    nand g3(n3, b, n1);
    
    // Second XOR (c^d) using 3 NANDs
    nand g4(n4, c, d);
    nand g5(n5, c, n4);
    nand g6(n6, d, n4);
    
    // Final XOR between the two results using 2 NANDs
    nand g7(n7, n2, n3);
    nand g8(n8, n5, n6);
    nand g9(out, n7, n8);

endmodule