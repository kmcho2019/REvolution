module sub_64bit(
    input   wire [63:0] A,
    input   wire [63:0] B,
    output  wire [63:0] result,
    output  wire        overflow
);

    wire [63:0] temp_result;
    assign temp_result = A - B;

    assign result = temp_result;

    // Check for overflow conditions
    assign overflow = ((A[63] == 0 && B[63] == 1 && temp_result[63] == 1) ||  // Positive overflow
                      (A[63] == 1 && B[63] == 0 && temp_result[63] == 0));  // Negative overflow

endmodule