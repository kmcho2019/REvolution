module TwoInputNAND (
    input a, b,
    output y
);
    assign y = ~(a & b);
endmodule

module FourInputNAND_Tree (
    input a, b, c, d,
    output y
);
    wire intermediate1, intermediate2;
    
    // First level NANDs
    TwoInputNAND gate1 (.a(a), .b(b), .y(intermediate1));
    TwoInputNAND gate2 (.a(c), .b(d), .y(intermediate2));
    
    // Final NAND
    TwoInputNAND gate3 (.a(intermediate1), .b(intermediate2), .y(y));
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First 4-input NAND using tree structure
    FourInputNAND_Tree gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Second 4-input NAND using tree structure
    FourInputNAND_Tree gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule