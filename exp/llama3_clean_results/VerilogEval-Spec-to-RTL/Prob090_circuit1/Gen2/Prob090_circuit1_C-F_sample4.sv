module TopModule(
    input  a,
    input  b,
    output reg q // Explicitly declaring q as a reg for clarity
);
    
    // Using a continuous assignment for efficiency
    assign q = a & b;

    // Optional: Consider adding a buffer for the output if necessary
    // However, this is typically managed by the synthesis tool

endmodule