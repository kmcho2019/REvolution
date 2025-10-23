module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Behavioral description that synthesizes to:
    // bit0_match = A[0] XNOR B[0]
    // bit1_match = A[1] XNOR B[1]
    // z = bit0_match AND bit1_match
    assign z = (A == B);
endmodule