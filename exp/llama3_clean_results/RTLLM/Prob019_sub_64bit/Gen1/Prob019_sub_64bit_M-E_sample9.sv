module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Divide the 64-bit numbers into two 32-bit parts: high and low
    wire [31:0] A_high = A[63:32];
    wire [31:0] A_low  = A[31:0];
    wire [31:0] B_high = B[63:32];
    wire [31:0] B_low  = B[31:0];

    // Perform subtraction on the low parts
    wire [31:0] low_result;
    wire       low_borrow;
    assign {low_borrow, low_result} = {1'b0, A_low} - {1'b0, B_low};

    // Perform subtraction on the high parts, considering the borrow from the low part
    wire [31:0] high_result;
    wire       high_borrow;
    assign {high_borrow, high_result} = {1'b0, A_high} - {1'b0, B_high} - {31'b0, low_borrow};

    // Combine the high and low results to form the final 64-bit result
    assign result = {high_result, low_result};

    // Detect overflow conditions by examining the sign bits of A, B, and the result
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) || 
                     (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0) || 
                     (high_borrow == 1'b1);

endmodule