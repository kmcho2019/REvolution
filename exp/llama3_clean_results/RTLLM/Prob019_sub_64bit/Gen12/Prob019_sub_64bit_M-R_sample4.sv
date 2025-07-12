module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Perform subtraction and assign result
    assign result = A - B;

    // Extract sign bits of A, B, and result
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    // Simplified overflow detection logic using continuous assignment
    assign overflow = (sign_A!= sign_B) && (sign_A!= sign_result)? 1'b1 : 1'b0;

endmodule