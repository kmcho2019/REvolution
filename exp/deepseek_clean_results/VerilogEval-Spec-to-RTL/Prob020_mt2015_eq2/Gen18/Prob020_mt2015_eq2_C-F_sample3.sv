module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Behavioral implementation that synthesizes to optimal gate-level structure:
    // - Two XNOR gates for bitwise comparison (A[0]≡B[0] and A[1]≡B[1])
    // - One AND gate to combine comparison results
    assign z = (A == B);
endmodule