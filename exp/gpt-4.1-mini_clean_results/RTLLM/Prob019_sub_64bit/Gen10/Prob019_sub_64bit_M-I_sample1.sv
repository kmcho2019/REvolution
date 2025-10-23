module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction using signed arithmetic for clean synthesis
    wire signed [63:0] sA = A;
    wire signed [63:0] sB = B;
    wire signed [63:0] sResult;

    assign sResult = sA - sB;
    assign result = sResult;

    // Overflow detection for signed subtraction:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = sA[63];
    wire B_sign      = sB[63];
    wire result_sign = sResult[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule