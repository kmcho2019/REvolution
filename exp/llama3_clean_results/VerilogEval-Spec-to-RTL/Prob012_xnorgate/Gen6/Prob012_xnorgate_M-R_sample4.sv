module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Simplified XNOR implementation using bitwise XOR and inversion
    assign out = ~(a ^ b);

endmodule