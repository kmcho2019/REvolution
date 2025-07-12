module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Internal signals
    wire both_high;
    wire both_low;
    
    // Check when both inputs are high (1) or both are low (0)
    assign both_high = a & b;
    assign both_low = ~a & ~b;
    
    // Use OR gate to combine the results
    assign out = both_high | both_low;

endmodule