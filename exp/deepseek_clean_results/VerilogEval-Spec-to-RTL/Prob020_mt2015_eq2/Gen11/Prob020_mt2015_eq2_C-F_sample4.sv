module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Implements 2-bit equality comparison using:
    // z = (A[1] XNOR B[1]) AND (A[0] XNOR B[0])
    assign z = (A == B);
endmodule