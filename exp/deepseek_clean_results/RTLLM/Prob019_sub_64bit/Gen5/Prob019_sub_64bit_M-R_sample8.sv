module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

// Intermediate signals for overflow detection
wire A_positive = ~A[63];
wire A_negative = A[63];
wire B_positive = ~B[63];
wire B_negative = B[63];
wire result_positive = ~result[63];
wire result_negative = result[63];

// Positive overflow: A positive, B negative, result negative
wire positive_overflow = A_positive & B_negative & result_negative;

// Negative overflow: A negative, B positive, result positive
wire negative_overflow = A_negative & B_positive & result_positive;

// Main subtraction operation
assign result = A - B;

// Combined overflow detection
assign overflow = positive_overflow | negative_overflow;

endmodule