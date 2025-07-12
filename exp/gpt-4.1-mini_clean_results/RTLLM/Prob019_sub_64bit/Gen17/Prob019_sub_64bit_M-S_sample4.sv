module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction using Verilog '+' operator:
    // result = A + (~B) + 1, equivalent to A - B
    wire [64:0] full_result = {1'b0, A} + {1'b0, ~B} + 1'b1;
    assign result = full_result[63:0];

    // Overflow detection for signed subtraction:
    // Overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule