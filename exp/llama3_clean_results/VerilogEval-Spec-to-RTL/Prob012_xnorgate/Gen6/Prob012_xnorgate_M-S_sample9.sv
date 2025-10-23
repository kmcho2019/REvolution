module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Simplified XNOR implementation using equality operator
    assign out = ~(a ^ b); // Using XOR and NOT operators for XNOR

endmodule