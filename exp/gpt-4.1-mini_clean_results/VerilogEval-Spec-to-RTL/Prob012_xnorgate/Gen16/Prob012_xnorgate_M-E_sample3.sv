module TopModule(
    input  a,
    input  b,
    output out
);
    wire xor_ab;
    
    // XOR gate: xor_ab = a ^ b
    assign xor_ab = a ^ b;
    // Invert xor_ab to get XNOR output
    assign out = ~xor_ab;
    
endmodule