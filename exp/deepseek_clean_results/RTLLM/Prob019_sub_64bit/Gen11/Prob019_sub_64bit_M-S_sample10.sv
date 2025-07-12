module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output [63:0] result,
    output overflow
);

    // Behavioral subtraction - tools will optimize implementation
    assign result = A - B;

    // Simplified overflow detection
    assign overflow = (A[63] != B[63]) && (result[63] != A[63]);

endmodule