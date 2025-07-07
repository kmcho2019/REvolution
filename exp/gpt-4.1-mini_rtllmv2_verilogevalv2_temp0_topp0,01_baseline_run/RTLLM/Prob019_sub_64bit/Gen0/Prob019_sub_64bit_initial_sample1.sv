module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    // Overflow detection:
    // Overflow occurs if:
    // 1) A is positive (sign_A=0), B is negative (sign_B=1), and result is negative (sign_result=1)
    // 2) A is negative (sign_A=1), B is positive (sign_B=0), and result is positive (sign_result=0)
    assign overflow = (~sign_A &  sign_B &  sign_result) |
                      ( sign_A & ~sign_B & ~sign_result);

endmodule