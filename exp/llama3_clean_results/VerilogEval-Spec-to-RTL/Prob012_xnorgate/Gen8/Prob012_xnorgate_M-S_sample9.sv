module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Simplified XNOR implementation using logical expression
    assign out = ~(a ^ b);

endmodule