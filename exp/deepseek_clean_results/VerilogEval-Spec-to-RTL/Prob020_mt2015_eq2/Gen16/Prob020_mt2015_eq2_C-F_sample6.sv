module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit0_match, bit1_match;
    
    // Explicit gate instantiation for bitwise comparison
    xnor bit0_compare(bit0_match, A[0], B[0]);
    xnor bit1_compare(bit1_match, A[1], B[1]);
    
    // Early termination AND gate
    and final_output(z, bit0_match, bit1_match);
endmodule