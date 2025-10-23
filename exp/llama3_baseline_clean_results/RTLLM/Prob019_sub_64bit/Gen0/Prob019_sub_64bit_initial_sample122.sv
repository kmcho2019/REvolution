module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    wire [63:0] temp_result;
    assign temp_result = A - B;

    // Check for overflow by examining sign bits
    assign result = temp_result;
    assign overflow = (A[63] == 0 && B[63] == 1 && temp_result[63] == 1) || // Positive overflow
                     (A[63] == 1 && B[63] == 0 && temp_result[63] == 0); // Negative overflow

endmodule