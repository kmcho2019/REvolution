module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal signals for bit-level comparisons
    wire [3:0] a_gt_b; // A greater than B at each bit position
    wire [3:0] a_lt_b; // A less than B at each bit position

    // Bit-level comparators
    for (genvar i = 0; i < 4; i++) begin
        assign a_gt_b[i] = (A[i] == 1 && B[i] == 0);
        assign a_lt_b[i] = (A[i] == 0 && B[i] == 1);
    end

    // Priority encoder to determine overall relationship
    assign A_greater = (a_gt_b[3] || (a_gt_b[2] && ~a_lt_b[3]) || (a_gt_b[1] && ~a_lt_b[3] && ~a_lt_b[2]) || (a_gt_b[0] && ~a_lt_b[3] && ~a_lt_b[2] && ~a_lt_b[1]));
    assign A_less  = (a_lt_b[3] || (a_lt_b[2] && ~a_gt_b[3]) || (a_lt_b[1] && ~a_gt_b[3] && ~a_gt_b[2]) || (a_lt_b[0] && ~a_gt_b[3] && ~a_gt_b[2] && ~a_gt_b[1]));
    assign A_equal = ~(A_greater || A_less);

endmodule