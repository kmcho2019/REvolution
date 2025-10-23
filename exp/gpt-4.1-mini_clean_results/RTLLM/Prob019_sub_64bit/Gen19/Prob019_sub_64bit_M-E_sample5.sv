module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction as A + (~B) + 1 using Verilog addition operator
    wire [63:0] B_comp = ~B;
    wire [64:0] sum_ext = {1'b0, A} + {1'b0, B_comp} + 1'b1;
    assign result = sum_ext[63:0];

    // Extract sign bits for overflow detection
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    // Overflow detection for subtraction:
    // Overflow occurs if signs of A and B differ, and sign of result differs from sign of A
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule