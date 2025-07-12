module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and zero flags
wire borrow;
wire zero;

// Subtractor module to compute A - B
subtractor_3bit sub(
    .A(A),
    .B(B),
    .borrow(borrow),
    .zero(zero)
);

// Decoder to interpret subtractor output and set comparison outputs
assign A_greater = ~borrow & ~zero;
assign A_equal = zero;
assign A_less = borrow;

endmodule

// Subtractor module
module subtractor_3bit(
    input [2:0] A,
    input [2:0] B,
    output borrow,
    output zero
);

// Internal signals for difference and borrow at each bit position
wire [2:0] diff;
wire [1:0] borrow_int;

// Full subtractor for each bit
full_subtractor fs0(
    .A(A[0]),
    .B(B[0]),
    .B_in(1'b0),
    .D(diff[0]),
    .B_out(borrow_int[0])
);

full_subtractor fs1(
    .A(A[1]),
    .B(B[1]),
    .B_in(borrow_int[0]),
    .D(diff[1]),
    .B_out(borrow_int[1])
);

full_subtractor fs2(
    .A(A[2]),
    .B(B[2]),
    .B_in(borrow_int[1]),
    .D(diff[2]),
    .B_out(borrow)
);

// Zero flag if all bits of difference are zero
assign zero = ~(diff[0] | diff[1] | diff[2]);

endmodule

// Full subtractor module
module full_subtractor(
    input A,
    input B,
    input B_in,
    output D,
    output B_out
);

assign D = A ^ B ^ B_in;
assign B_out = (B & ~A) | (B_in & (~A ^ B));

endmodule