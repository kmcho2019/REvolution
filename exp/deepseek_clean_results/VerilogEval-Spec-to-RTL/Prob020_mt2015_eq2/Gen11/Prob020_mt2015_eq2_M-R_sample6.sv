module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bit-wise equality check using XNOR followed by AND reduction
    assign z = (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
endmodule