// XNOR gate implemented structurally
module TopModule (
    input a,
    input b,
    output out
);
    // Intermediate XOR result
    wire xor_result;
    
    // First compute XOR
    assign xor_result = a ^ b;
    
    // Then invert to get XNOR
    assign out = ~xor_result;
    
    /* Original implementation for comparison:
    // assign out = a ~^ b;
    */
endmodule