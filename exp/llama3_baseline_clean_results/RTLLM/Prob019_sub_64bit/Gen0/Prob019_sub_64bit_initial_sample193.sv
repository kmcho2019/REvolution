module sub_64bit (
    input   logic [63:0] A,
    input   logic [63:0] B,
    output  logic [63:0] result,
    output  logic        overflow
);

    logic [63:0] temp_result;
    logic       A_sign, B_sign, result_sign;

    assign temp_result = A - B;
    assign A_sign      = A[63];
    assign B_sign      = B[63];
    assign result_sign = temp_result[63];

    assign overflow = (A_sign == 0 && B_sign == 1 && result_sign == 1) || 
                      (A_sign == 1 && B_sign == 0 && result_sign == 0);

    assign result = temp_result;

endmodule