module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    assign result = A - B;

    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_res = result[63];

    // Overflow detection for signed subtraction:
    // Overflow if A and B have different signs and result sign differs from A sign.
    assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_res == 1'b1) // positive overflow
                   || (sign_A == 1'b1 && sign_B == 1'b0 && sign_res == 1'b0); // negative overflow

endmodule