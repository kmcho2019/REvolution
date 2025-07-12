module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    wire not_x0;
    wire term1, term2;
    
    // NOT x[0] using NAND
    nand n1(not_x0, x[0], x[0]);
    
    // First term: ~x[0] & x[2] implemented as NAND followed by NOT
    nand n2(term1, not_x0, x[2]);
    
    // Second term: x[0] & x[1] & x[3] implemented as 3-input NAND followed by NOT
    nand n3(term2, x[0], x[1], x[3]);
    
    // Combine terms using NAND (equivalent to OR of original terms)
    nand n4(f, term1, term2);
endmodule