module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [64:0] full_sub;  // 65-bit to detect overflow on MSB

    // Perform A - B as A + (~B) + 1 using built-in addition
    assign full_sub = {1'b0, A} + {1'b0, ~B} + 1'b1;
    assign result = full_sub[63:0];

    // Extract sign bits
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    // Overflow occurs if A and B have different signs and result sign differs from A
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule