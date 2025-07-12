module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Equivalent implementation using explicit bitwise comparison
    assign z = (A[1] ~^ B[1]) & (A[0] ~^ B[0]);

endmodule