// Structural XNOR gate implementation
module TopModule (
    input a,
    input b,
    output out
);
    // Intermediate XOR result
    wire xor_out;
    
    // First compute XOR
    assign xor_out = a ^ b;
    
    // Then invert to get XNOR
    assign out = ~xor_out;
    
    /* Original implementation for reference:
    // Direct XNOR operator
    // assign out = a ~^ b;
    */
endmodule