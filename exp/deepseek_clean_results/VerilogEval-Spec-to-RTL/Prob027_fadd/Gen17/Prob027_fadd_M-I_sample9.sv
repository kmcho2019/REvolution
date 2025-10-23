module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Intermediate terms
    wire ab_nand, ac_nand, bc_nand;
    wire ab, ac, bc;
    
    // Generate all pairwise NANDs
    assign ab_nand = ~(a & b);
    assign ac_nand = ~(a & cin);
    assign bc_nand = ~(b & cin);
    
    // Invert NAND terms for sum calculation
    assign ab = ~ab_nand;
    assign ac = ~ac_nand;
    assign bc = ~bc_nand;
    
    // Sum calculation (majority function)
    assign sum = ~(ab_nand & ac_nand & bc_nand);
    
    // Carry-out calculation
    assign cout = ~(ab_nand | ac_nand | bc_nand);
endmodule