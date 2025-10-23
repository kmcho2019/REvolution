module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

// Internal wires
wire A_positive = ~A[63];
wire B_negative = B[63];
wire result_negative = result[63];

wire A_negative = A[63];
wire B_positive = ~B[63];
wire result_positive = ~result[63];

// Positive overflow: A>0, B<0, result<0
wire pos_overflow = A_positive & B_negative & result_negative;

// Negative overflow: A<0, B>0, result>0
wire neg_overflow = A_negative & B_positive & result_positive;

// Main operations
assign result = A - B;
assign overflow = pos_overflow | neg_overflow;

endmodule