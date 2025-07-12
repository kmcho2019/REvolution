module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire msb_equal, msb1_equal;

assign msb_equal = A[2] == B[2];
assign msb1_equal = A[1] == B[1];

assign A_greater = (A[2] > B[2]) || (msb_equal && (A[1] > B[1])) || (msb_equal && msb1_equal && (A[0] > B[0]));
assign A_equal = (A == B);
assign A_less = (A[2] < B[2]) || (msb_equal && (A[1] < B[1])) || (msb_equal && msb1_equal && (A[0] < B[0]));

endmodule