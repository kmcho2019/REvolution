module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Optimal fused implementation using bitwise equality
    // Cases where z=1 (documented for clarity):
    // 4'b0000 (A=00, B=00)
    // 4'b0101 (A=01, B=01)
    // 4'b1010 (A=10, B=10)
    // 4'b1111 (A=11, B=11)
    assign z = (A == B);
    
    /* Implementation notes:
     * - Uses built-in equality operator for optimal synthesis
     * - Typically synthesizes to XNOR gates + AND gate
     * - Clear documentation of all true cases
     * - No unnecessary intermediate signals
     */
endmodule