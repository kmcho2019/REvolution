// Simple AND gate implementation
module AND_Gate (
    input  a,    // First input
    input  b,    // Second input
    output q     // Output (a AND b)
);
    // Continuous assignment for combinational logic
    assign q = a & b;
endmodule