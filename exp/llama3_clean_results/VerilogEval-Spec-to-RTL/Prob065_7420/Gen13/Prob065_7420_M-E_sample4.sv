// Define a module for a 2-input NAND gate
module NAND2(
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

// Define a module for a 4-input NAND gate using 2-input NAND gates
module NAND4Hierarchical(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire  n1, n2;
    
    // First level of NAND gates
    NAND2 nand1(
       .a(a),
       .b(b),
       .y(n1)
    );
    
    NAND2 nand2(
       .a(c),
       .b(d),
       .y(n2)
    );
    
    // Second level of NAND gate
    NAND2 nand3(
       .a(n1),
       .b(n2),
       .y(y)
    );
endmodule

// Top module that instantiates two 4-input NAND gates
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
    NAND4Hierarchical nand1(
       .a(p1a),
       .b(p1b),
       .c(p1c),
       .d(p1d),
       .y(p1y)
    );
    
    NAND4Hierarchical nand2(
       .a(p2a),
       .b(p2b),
       .c(p2c),
       .d(p2d),
       .y(p2y)
    );
endmodule