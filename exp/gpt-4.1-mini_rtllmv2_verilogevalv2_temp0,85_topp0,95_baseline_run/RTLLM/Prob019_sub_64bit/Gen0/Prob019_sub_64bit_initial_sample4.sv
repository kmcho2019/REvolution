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

    // Detect overflow
    // Overflow occurs when:
    // A positive - B negative results in negative (pos overflow)
    // A negative - B positive results in positive (neg overflow)
    assign overflow = ( (sign_A == 1'b0 && sign_B == 1'b1 && sign_res == 1'b1) ||
                        (sign_A == 1'b1 && sign_B == 1'b0 && sign_res == 1'b0) );

endmodule