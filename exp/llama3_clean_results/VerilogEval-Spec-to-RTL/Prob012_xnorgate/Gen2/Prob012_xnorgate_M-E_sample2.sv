module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Using AND and OR gates to implement XNOR
    wire both_zero, both_one;
    assign both_zero = ~(a) & ~(b); // Both inputs are 0
    assign both_one = a & b; // Both inputs are 1
    assign out = both_zero | both_one; // Output is 1 when both inputs are the same

endmodule