module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    /* Even parity detector - optimized implementation
     * Uses built-in XOR reduction for optimal PPA
     * Synthesis tool will select best implementation
     */
    assign q = ~^ {a, b, c, d}; // XOR reduction operator
    
    // Alternative if XOR reduction not supported:
    // assign q = ~(a ^ b ^ c ^ d);
endmodule