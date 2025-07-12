module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct magnitude comparison
wire A_gt_B = (A > B);
wire A_eq_B = (A == B);

// Output assignment - mutually exclusive by construction
assign A_greater = A_gt_B;
assign A_equal = A_eq_B;
assign A_less = ~(A_gt_B | A_eq_B);

endmodule