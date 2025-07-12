module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Primary implementation - optimal PPA
    assign z = (A == B);
    
    /* Alternative gate-level implementation (equivalent functionality)
    wire bit0_match, bit1_match;
    assign bit0_match = ~(A[0] ^ B[0]);  // XNOR for bit 0
    assign bit1_match = ~(A[1] ^ B[1]);  // XNOR for bit 1
    assign z = bit0_match & bit1_match;   // AND of matches
    */
endmodule