module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Implements 2-bit equality comparator with optimal PPA
    // Synthesizes to:
    // - Bitwise XNOR gates for A[0] vs B[0] and A[1] vs B[1]
    // - AND gate to combine comparison results
    // Power-optimized by minimal switching activity
    // Area-optimized through direct equality operator
    assign z = (A == B);
endmodule