module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

wire a_gt_b;
wire a_lt_b;
wire a_eq_b;

// Hierarchical bitwise comparison from MSB to LSB
assign a_gt_b = (A[2] & ~B[2])                        ? 1'b1 :
                (A[2] == B[2]) ? 
                   ((A[1] & ~B[1])                    ? 1'b1 :
                    (A[1] == B[1]) ? 
                       ((A[0] & ~B[0])                ? 1'b1 : 1'b0) 
                    : 1'b0) 
                : 1'b0;

assign a_lt_b = (~A[2] & B[2])                        ? 1'b1 :
                (A[2] == B[2]) ? 
                   ((~A[1] & B[1])                    ? 1'b1 :
                    (A[1] == B[1]) ? 
                       ((~A[0] & B[0])                ? 1'b1 : 1'b0) 
                    : 1'b0) 
                : 1'b0;

assign a_eq_b = (A == B);

assign A_greater = a_gt_b;
assign A_less    = a_lt_b;
assign A_equal   = a_eq_b;

endmodule