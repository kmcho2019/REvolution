module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Continuous assignment for the subtraction operation
    assign result = A - B;

    // Continuous assignment for overflow detection
    assign overflow = (A[63]!= result[63]) && (A[63]!= B[63])? 1'b1 : 1'b0;

endmodule