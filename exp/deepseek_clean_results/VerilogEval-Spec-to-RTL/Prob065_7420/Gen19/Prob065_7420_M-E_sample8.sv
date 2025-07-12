module Decomposed4NAND (
    input a, b, c, d,
    output y
);
    wire nand_ab, nand_cd, nand_ab_cd;
    wire nand_bc, nand_da, nand_bc_da;
    
    // First level of NANDs
    assign nand_ab = ~(a & b);
    assign nand_cd = ~(c & d);
    assign nand_bc = ~(b & c);
    assign nand_da = ~(d & a);
    
    // Second level of NANDs
    assign nand_ab_cd = ~(nand_ab & nand_cd);
    assign nand_bc_da = ~(nand_bc & nand_da);
    
    // Final NAND
    assign y = ~(nand_ab_cd & nand_bc_da);
endmodule

module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First 4-input NAND using decomposed structure
    Decomposed4NAND nand1 (
        .a(p1a), .b(p1b), .c(p1c), .d(p1d),
        .y(p1y)
    );
    
    // Second 4-input NAND using decomposed structure
    Decomposed4NAND nand2 (
        .a(p2a), .b(p2b), .c(p2c), .d(p2d),
        .y(p2y)
    );
endmodule