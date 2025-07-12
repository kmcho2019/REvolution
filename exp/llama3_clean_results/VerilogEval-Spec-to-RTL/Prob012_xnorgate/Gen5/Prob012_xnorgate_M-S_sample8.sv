module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Simplified XNOR implementation using bitwise XOR and NOT
    assign out = ~(a ^ b);

endmodule