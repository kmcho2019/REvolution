// Optimal implementation using direct XNOR operator
module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Most efficient implementation
    
    /* Alternative structural implementation for reference:
    wire xor_out;
    assign xor_out = a ^ b;
    assign out = ~xor_out;  // XNOR is NOT of XOR
    */
endmodule