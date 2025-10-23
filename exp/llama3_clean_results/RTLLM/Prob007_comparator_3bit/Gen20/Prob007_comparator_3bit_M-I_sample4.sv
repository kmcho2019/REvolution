module comparator_3bit(
    input logic [2:0] A,
    input logic [2:0] B,
    output logic A_greater,
    output logic A_equal,
    output logic A_less
);

logic A_eq_B, A_gt_B, A_lt_B;

assign A_eq_B = (A == B);
assign A_gt_B = (A > B);
assign A_lt_B = (A < B);

assign A_greater = A_gt_B & ~A_eq_B;
assign A_equal = A_eq_B;
assign A_less = A_lt_B & ~A_eq_B;

endmodule