module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire bit1_equal, bit0_equal;

    assign bit1_equal = ~(A[1] ^ B[1]);  // XNOR for MSB
    assign bit0_equal = ~(A[0] ^ B[0]);  // XNOR for LSB
    assign z = bit1_equal & bit0_equal;  // Final AND to check both bits

endmodule