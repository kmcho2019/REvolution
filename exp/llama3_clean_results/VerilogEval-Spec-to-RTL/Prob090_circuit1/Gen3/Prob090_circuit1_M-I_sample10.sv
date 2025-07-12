module TopModule(
    input  a,
    input  b,
    output reg q
);
    
    // Using a continuous assignment for efficiency
    assign q = a & b;

    // No additional optimizations are necessary for this simple AND gate implementation
    // The synthesis tool will typically handle buffer insertion and other optimizations

endmodule