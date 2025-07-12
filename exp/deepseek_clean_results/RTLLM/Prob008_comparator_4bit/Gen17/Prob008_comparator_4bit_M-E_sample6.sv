module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Segment comparison (2-bit chunks)
wire [1:0] seg_greater, seg_less, seg_equal;

// MSB segment (bits 3-2)
assign seg_greater[1] = (A[3] > B[3]) | 
                        (A[3] == B[3] & A[2] > B[2]);
assign seg_less[1] = (A[3] < B[3]) | 
                     (A[3] == B[3] & A[2] < B[2]);
assign seg_equal[1] = (A[3] == B[3]) & (A[2] == B[2]);

// LSB segment (bits 1-0)
assign seg_greater[0] = (A[1] > B[1]) | 
                        (A[1] == B[1] & A[0] > B[0]);
assign seg_less[0] = (A[1] < B[1]) | 
                     (A[1] == B[1] & A[0] < B[0]);
assign seg_equal[0] = (A[1] == B[1]) & (A[0] == B[0]);

// Prefix combination rules
assign A_greater = seg_greater[1] | 
                  (seg_equal[1] & seg_greater[0]);
assign A_less = seg_less[1] | 
               (seg_equal[1] & seg_less[0]);
assign A_equal = seg_equal[1] & seg_equal[0];

endmodule