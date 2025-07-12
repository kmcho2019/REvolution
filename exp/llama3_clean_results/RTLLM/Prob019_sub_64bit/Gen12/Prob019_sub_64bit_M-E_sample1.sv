module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    wire [31:0] A_high, A_low, B_high, B_low;
    wire [31:0] result_high, result_low;
    wire borrow_low, borrow_high;
    reg [31:0] temp_result;

    assign A_high = A[63:32];
    assign A_low = A[31:0];
    assign B_high = B[63:32];
    assign B_low = B[31:0];

    // Perform subtraction in two stages
    assign result_low = A_low - B_low;
    assign borrow_low = (A_low < B_low) ? 1'b1 : 1'b0;

    // Handle borrow from high 32 bits if necessary
    assign temp_result = A_high - B_high - borrow_low;
    assign borrow_high = (A_high < (B_high + borrow_low)) ? 1'b1 : 1'b0;

    assign result_high = temp_result;
    assign result = {result_high, result_low};

    // Overflow detection based on sign bits and borrow
    assign overflow = (A[63] == B[63] && A[63] != result[63]) || borrow_high;

endmodule