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
    wire sign_res = result[63];

    // Overflow detection
    // Overflow if:
    // 1) A positive (sign_A=0), B negative (sign_B=1), and result negative (sign_res=1) => positive overflow
    // 2) A negative (sign_A=1), B positive (sign_B=0), and result positive (sign_res=0) => negative overflow
    assign overflow = (~sign_A & sign_B & sign_res) | (sign_A & ~sign_B & ~sign_res);

endmodule