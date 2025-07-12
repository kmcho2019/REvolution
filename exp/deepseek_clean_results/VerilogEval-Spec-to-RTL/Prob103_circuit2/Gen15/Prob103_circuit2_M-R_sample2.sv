module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    /* Even parity detector - structural implementation
     * Explicitly shows the XOR gate structure
     */
    wire xor_ab, xor_cd, xor_abcd;
    
    assign xor_ab = a ^ b;
    assign xor_cd = c ^ d;
    assign xor_abcd = xor_ab ^ xor_cd;
    assign q = ~xor_abcd;  // Invert final XOR to detect even parity
endmodule