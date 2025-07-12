module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    /* Even Parity Detector
     * Outputs 1 when an even number of inputs are high
     * Optimal implementation using XOR reduction operator
     */
    assign q = ~(a ^ b ^ c ^ d);
endmodule