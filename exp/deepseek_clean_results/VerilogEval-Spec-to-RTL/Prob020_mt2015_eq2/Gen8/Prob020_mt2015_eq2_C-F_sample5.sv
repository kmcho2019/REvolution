module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Direct equality comparison (synthesizes to XNOR gates + AND gate)
    // Equivalent to: (~(A[0]^B[0])) & (~(A[1]^B[1]))
    assign z = (A == B);

endmodule