module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction using signed arithmetic
    wire signed [63:0] A_signed = A;
    wire signed [63:0] B_signed = B;
    wire signed [63:0] res_signed = A_signed - B_signed;

    assign result = res_signed;

    // Overflow occurs if signs of A and B differ and sign of result differs from A's sign
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire res_sign = res_signed[63];
    assign overflow = (A_sign != B_sign) && (res_sign != A_sign);

endmodule