module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform bitwise subtraction of A and B
    wire [63:0] borrow;
    assign borrow = ~A + 1;
    assign result = A + (~B + 1);

    // Novel overflow detection mechanism
    wire sign_A, sign_B, sign_result;
    assign sign_A = A[63];
    assign sign_B = B[63];
    assign sign_result = result[63];
    assign overflow = (sign_A == 1 && sign_B == 0 && sign_result == 0) || (sign_A == 0 && sign_B == 1 && sign_result == 1);

endmodule