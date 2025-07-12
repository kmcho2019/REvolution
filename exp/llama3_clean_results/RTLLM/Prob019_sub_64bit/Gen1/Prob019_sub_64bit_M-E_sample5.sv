module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

wire [63:0] B_twos_complement;
assign B_twos_complement = ~B + 1;

wire [63:0] sum;
assign sum = A + B_twos_complement;

assign result = sum;

wire A_sign;
assign A_sign = A[63];

wire B_sign;
assign B_sign = B[63];

wire result_sign;
assign result_sign = result[63];

overflow_detector ovf_det(
    .A_sign(A_sign),
    .B_sign(B_sign),
    .result_sign(result_sign),
    .overflow(overflow)
);

endmodule

module overflow_detector(
    input   A_sign,
    input   B_sign,
    input   result_sign,
    output  overflow
);

assign overflow = (A_sign == 0 && B_sign == 1 && result_sign == 1) ||
                  (A_sign == 1 && B_sign == 0 && result_sign == 0);

endmodule