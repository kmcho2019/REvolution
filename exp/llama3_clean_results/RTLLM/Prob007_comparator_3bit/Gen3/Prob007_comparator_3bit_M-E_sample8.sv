module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for 1-bit comparator outputs
wire [2:0] a_greater_int;
wire [2:0] a_equal_int;
wire [2:0] a_less_int;

// Instantiate 1-bit comparators for each bit position
one_bit_comparator comp_msbs(
    .A(A[2]),
    .B(B[2]),
    .A_greater(a_greater_int[2]),
    .A_equal(a_equal_int[2]),
    .A_less(a_less_int[2])
);

one_bit_comparator comp_mids(
    .A(A[1]),
    .B(B[1]),
    .A_greater(a_greater_int[1]),
    .A_equal(a_equal_int[1]),
    .A_less(a_less_int[1])
);

one_bit_comparator comp_lsbs(
    .A(A[0]),
    .B(B[0]),
    .A_greater(a_greater_int[0]),
    .A_equal(a_equal_int[0]),
    .A_less(a_less_int[0])
);

// Determine overall comparison result based on 1-bit comparator outputs
assign A_greater = a_greater_int[2] || (a_equal_int[2] && a_greater_int[1]) || (a_equal_int[2] && a_equal_int[1] && a_greater_int[0]);
assign A_equal = a_equal_int[2] && a_equal_int[1] && a_equal_int[0];
assign A_less = a_less_int[2] || (a_equal_int[2] && a_less_int[1]) || (a_equal_int[2] && a_equal_int[1] && a_less_int[0]);

endmodule

// 1-bit comparator module
module one_bit_comparator(
    input A,
    input B,
    output A_greater,
    output A_equal,
    output A_less
);

assign A_greater = (A && ~B);
assign A_equal = (A == B);
assign A_less = (~A && B);

endmodule