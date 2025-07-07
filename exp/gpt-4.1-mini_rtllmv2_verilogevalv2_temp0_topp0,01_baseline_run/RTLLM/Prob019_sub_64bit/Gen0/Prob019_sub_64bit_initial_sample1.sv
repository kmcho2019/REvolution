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

    // Overflow detection
    // Overflow if A positive and B negative and result negative
    // or A negative and B positive and result positive
    assign overflow = ( (sign_A == 1'b0) && (sign_B == 1'b1) && (sign_result == 1'b1) ) ||
                      ( (sign_A == 1'b1) && (sign_B == 1'b0) && (sign_result == 1'b0) );

endmodule