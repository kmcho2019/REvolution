module TopModule (
    input a,
    input b,
    output out
);
    // Optimal implementation - direct XNOR operator
    assign out = a ~^ b;
    
    /* Alternative 1: LUT-based implementation (educational)
    parameter [3:0] XNOR_LUT = 4'b1001; // Truth table: 00->1, 01->0, 10->0, 11->1
    assign out = XNOR_LUT[{a, b}];
    */
    
    /* Alternative 2: Structural implementation
    wire xor_out;
    assign xor_out = a ^ b;
    assign out = ~xor_out;  // XNOR is NOT of XOR
    */
endmodule