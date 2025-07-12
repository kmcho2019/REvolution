module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Compare the bits of A and B from most significant to least significant
wire A_ms_greater = A[3] > B[3];
wire A_ms_equal = A[3] == B[3];
wire A_ms_less = A[3] < B[3];

wire A_ms1_greater = A[2] > B[2];
wire A_ms1_equal = A[2] == B[2];
wire A_ms1_less = A[2] < B[2];

wire A_ms2_greater = A[1] > B[1];
wire A_ms2_equal = A[1] == B[1];
wire A_ms2_less = A[1] < B[1];

// Determine the outputs based on the comparisons
assign A_greater = (A_ms_greater) || 
                  (A_ms_equal && A_ms1_greater) || 
                  (A_ms_equal && A_ms1_equal && A_ms2_greater) || 
                  (A_ms_equal && A_ms1_equal && A_ms2_equal && A[0] > B[0]);

assign A_equal = (A_ms_equal && A_ms1_equal && A_ms2_equal && A[0] == B[0]);

assign A_less = (A_ms_less) || 
               (A_ms_equal && A_ms1_less) || 
               (A_ms_equal && A_ms1_equal && A_ms2_less) || 
               (A_ms_equal && A_ms1_equal && A_ms2_equal && A[0] < B[0]);

endmodule