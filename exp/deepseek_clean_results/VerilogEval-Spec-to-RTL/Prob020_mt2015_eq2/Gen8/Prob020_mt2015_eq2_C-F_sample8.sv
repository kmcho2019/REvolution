module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // 2-bit equality comparator implemented as:
    // z = (A[1] XNOR B[1]) AND (A[0] XNOR B[0])
    assign z = (A == B);

endmodule