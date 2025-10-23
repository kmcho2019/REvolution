module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // MSB comparison
    wire A_gt_MSB = A[2] & ~B[2];
    wire A_eq_MSB = A[2] ~^ B[2];
    wire A_lt_MSB = ~A[2] & B[2];

    // Middle bit comparison
    wire A_gt_MID = A[1] & ~B[1];
    wire A_eq_MID = A[1] ~^ B[1];
    wire A_lt_MID = ~A[1] & B[1];

    // LSB comparison
    wire A_gt_LSB = A[0] & ~B[0];
    wire A_eq_LSB = A[0] ~^ B[0];
    wire A_lt_LSB = ~A[0] & B[0];

    // Parallel output calculation
    assign A_greater = A_gt_MSB | 
                      (A_eq_MSB & A_gt_MID) | 
                      (A_eq_MSB & A_eq_MID & A_gt_LSB);

    assign A_equal = A_eq_MSB & A_eq_MID & A_eq_LSB;

    assign A_less = A_lt_MSB | 
                   (A_eq_MSB & A_lt_MID) | 
                   (A_eq_MSB & A_eq_MID & A_lt_LSB);

endmodule