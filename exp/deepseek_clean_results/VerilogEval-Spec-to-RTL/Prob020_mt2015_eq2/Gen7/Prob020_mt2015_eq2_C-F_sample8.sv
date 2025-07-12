module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Optimal 2-bit equality comparator
    // Implements z = 1 when A == B, else 0
    // Synthesizes to minimal XNOR + AND structure
    assign z = (A == B);

endmodule