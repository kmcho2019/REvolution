module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit0_equal, bit1_equal;
    
    // Bitwise comparison
    xnor xnor0(bit0_equal, A[0], B[0]);
    xnor xnor1(bit1_equal, A[1], B[1]);
    
    // Final AND to check both bits match
    and final_and(z, bit0_equal, bit1_equal);
endmodule