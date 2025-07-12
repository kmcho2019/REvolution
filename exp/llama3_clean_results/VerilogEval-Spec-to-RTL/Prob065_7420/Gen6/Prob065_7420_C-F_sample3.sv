// Define a NAND4 module for modularity and reusability
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    // Assign the output as the negation of the AND of all inputs
    assign y = ~(a & b & c & d);
endmodule

// Define the TopModule that instantiates two NAND4 gates
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
    // Instantiate the first NAND4 gate
    NAND4 nand1(
       .a(p1a),
       .b(p1b),
       .c(p1c),
       .d(p1d),
       .y(p1y)
    );
    
    // Instantiate the second NAND4 gate
    NAND4 nand2(
       .a(p2a),
       .b(p2b),
       .c(p2c),
       .d(p2d),
       .y(p2y)
    );
endmodule