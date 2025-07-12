module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit0_match, bit1_match;
    
    // Bitwise comparison using XNOR gates
    xnor xnor0(bit0_match, A[0], B[0]);
    xnor xnor1(bit1_match, A[1], B[1]);
    
    // Final AND to check all bits match
    and final_and(z, bit0_match, bit1_match);

endmodule