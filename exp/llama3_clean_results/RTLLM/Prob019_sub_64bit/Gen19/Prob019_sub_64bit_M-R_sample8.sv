module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    wire [63:0] temp_result;
    assign temp_result = A - B;
    assign result = temp_result;

    // Overflow detection
    // Positive overflow: A is positive, B is negative, and result is negative
    // Negative overflow: A is negative, B is positive, and result is positive
    assign overflow = (A[63] == 0 && B[63] == 1 && temp_result[63] == 1) || 
                     (A[63] == 1 && B[63] == 0 && temp_result[63] == 0);

endmodule