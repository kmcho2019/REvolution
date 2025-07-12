module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    /* Even parity detector - structural implementation
     * Calculates parity through explicit XOR steps
     * Same functionality as XOR reduction operator
     */
    wire ab_xor, abc_xor;
    
    assign ab_xor = a ^ b;
    assign abc_xor = ab_xor ^ c;
    assign q = ~(abc_xor ^ d);  // Final inversion for even parity
    
    // Note: This will synthesize to the same XOR4 as the original
endmodule