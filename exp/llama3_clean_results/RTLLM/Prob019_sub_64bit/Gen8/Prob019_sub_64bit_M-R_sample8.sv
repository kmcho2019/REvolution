module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Perform subtraction and assign result
    assign result = A - B;

    // Simplified overflow detection logic using continuous assignment
    assign overflow = (A[63]!= result[63]) && (A[63]!= B[63])? 1'b1 : 1'b0;

endmodule