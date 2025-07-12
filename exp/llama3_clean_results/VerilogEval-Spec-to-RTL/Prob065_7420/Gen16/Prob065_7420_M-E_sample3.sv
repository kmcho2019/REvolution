// Define a reusable module for an 8-input NAND gate
module NAND8(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    input  f,
    input  g,
    input  h,
    output y
);
    assign y = ~(a & b & c & d & e & f & g & h);
endmodule

// Define the TopModule that implements the 7420 chip's functionality
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
    // Use an 8-input NAND gate to implement the dual 4-input NAND gates
    // Tie unused inputs to 1 (logic high) to ensure they don't affect the operation
    wire nand8_out;
    NAND8 nand8_gate(
       .a(p1a),
       .b(p1b),
       .c(p1c),
       .d(p1d),
       .e(1'b1), // Tie to 1
       .f(1'b1), // Tie to 1
       .g(1'b1), // Tie to 1
       .h(1'b1), // Tie to 1
       .y(nand8_out)
    );
    
    // Assign p1y directly from the 8-input NAND gate's output
    assign p1y = nand8_out;
    
    // For the second 4-input NAND gate, we need another instance
    // But this time, we connect the inputs directly to the second set of inputs
    // and tie the first set of inputs to 1 to not interfere
    wire nand8_out2;
    NAND8 nand8_gate2(
       .a(1'b1), // Tie to 1
       .b(1'b1), // Tie to 1
       .c(1'b1), // Tie to 1
       .d(1'b1), // Tie to 1
       .e(p2a),
       .f(p2b),
       .g(p2c),
       .h(p2d),
       .y(nand8_out2)
    );
    
    // Assign p2y from the second 8-input NAND gate's output
    assign p2y = nand8_out2;
endmodule