module TwoInputNAND (
    input a,
    input b,
    output y
);
    assign y = ~(a & b);
endmodule

module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    // Intermediate wires for first NAND group
    wire p1_ab_nand;
    wire p1_cd_nand;
    
    // First 4-input NAND decomposed
    TwoInputNAND gate1_1 (.a(p1a), .b(p1b), .y(p1_ab_nand));
    TwoInputNAND gate1_2 (.a(p1c), .b(p1d), .y(p1_cd_nand));
    TwoInputNAND gate1_3 (.a(p1_ab_nand), .b(p1_cd_nand), .y(p1y));
    
    // Intermediate wires for second NAND group
    wire p2_ab_nand;
    wire p2_cd_nand;
    
    // Second 4-input NAND decomposed
    TwoInputNAND gate2_1 (.a(p2a), .b(p2b), .y(p2_ab_nand));
    TwoInputNAND gate2_2 (.a(p2c), .b(p2d), .y(p2_cd_nand));
    TwoInputNAND gate2_3 (.a(p2_ab_nand), .b(p2_cd_nand), .y(p2y));
endmodule