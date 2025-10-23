module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Internal signals
    wire both_high;
    wire both_low;
    
    // Create signal that is high when both inputs are high
    assign both_high = a & b;
    
    // Create signal that is high when both inputs are low
    assign both_low = ~a & ~b;
    
    // Produce final XNOR output by ORing the two signals
    assign out = both_high | both_low;

endmodule