module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit0_match, bit1_match;
    
    // Mux-based 1-bit equality detectors
    // When A==B, mux outputs 1, otherwise 0
    assign bit0_match = (A[0] == B[0]) ? 1'b1 : 1'b0;
    assign bit1_match = (A[1] == B[1]) ? 1'b1 : 1'b0;
    
    // Combine results
    assign z = bit0_match & bit1_match;
endmodule