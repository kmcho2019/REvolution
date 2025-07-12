module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise equality signals
    wire [3:0] bit_equal;
    assign bit_equal[3] = (A[3] == B[3]);
    assign bit_equal[2] = (A[2] == B[2]);
    assign bit_equal[1] = (A[1] == B[1]);
    assign bit_equal[0] = (A[0] == B[0]);

    // Bit-wise greater signals (A > B at this bit position)
    wire [3:0] bit_greater;
    assign bit_greater[3] = (A[3] & ~B[3]);
    assign bit_greater[2] = (A[2] & ~B[2]);
    assign bit_greater[1] = (A[1] & ~B[1]);
    assign bit_greater[0] = (A[0] & ~B[0]);

    // Bit-wise less signals (A < B at this bit position)
    wire [3:0] bit_less;
    assign bit_less[3] = (~A[3] & B[3]);
    assign bit_less[2] = (~A[2] & B[2]);
    assign bit_less[1] = (~A[1] & B[1]);
    assign bit_less[0] = (~A[0] & B[0]);

    // Priority encoding for first non-equal bit
    wire first_diff_greater;
    wire first_diff_less;
    
    assign first_diff_greater = bit_greater[3] | 
                              (bit_equal[3] & bit_greater[2]) |
                              (bit_equal[3] & bit_equal[2] & bit_greater[1]) |
                              (bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_greater[0]);

    assign first_diff_less = bit_less[3] | 
                           (bit_equal[3] & bit_less[2]) |
                           (bit_equal[3] & bit_equal[2] & bit_less[1]) |
                           (bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_less[0]);

    // Final outputs
    assign A_equal = &bit_equal;  // All bits equal
    assign A_greater = first_diff_greater;
    assign A_less = first_diff_less;

endmodule