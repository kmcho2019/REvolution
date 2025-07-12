module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Divide the 64-bit numbers into 32-bit segments
    wire [31:0] A_high = A[63:32];
    wire [31:0] A_low  = A[31:0];
    wire [31:0] B_high = B[63:32];
    wire [31:0] B_low  = B[31:0];

    // Perform subtraction on the low 32-bit segments
    wire [31:0] low_result;
    wire         low_carry;
    assign low_result = A_low - B_low;
    assign low_carry  = (A_low < B_low) ? 1'b1 : 1'b0;

    // Perform subtraction on the high 32-bit segments, considering the carry from the low segment
    wire [31:0] high_result;
    wire         high_carry;
    assign high_result = A_high - B_high - low_carry;
    assign high_carry  = (A_high < (B_high + low_carry)) ? 1'b1 : 1'b0;

    // Combine the results of the high and low segments
    assign result = {high_result, low_result};

    // Detect overflow conditions based on the carry signals
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]) || high_carry;

endmodule