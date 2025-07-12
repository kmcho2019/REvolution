module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

wire A_sign = A[63];
wire B_sign = B[63];
wire result_sign;

always @(*) begin
    result = A - B;
    result_sign = result[63];
    
    // Overflow occurs when:
    // 1. A is positive, B is negative, and result is negative (positive overflow)
    // 2. A is negative, B is positive, and result is positive (negative overflow)
    overflow = (~A_sign & B_sign & result_sign) | (A_sign & ~B_sign & ~result_sign);
end

endmodule