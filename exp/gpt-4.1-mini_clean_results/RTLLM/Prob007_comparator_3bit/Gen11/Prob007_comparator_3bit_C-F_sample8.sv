module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Equality check: use XOR reduction to detect any differing bit
    wire diff_bits = |(A ^ B);
    assign A_equal = ~diff_bits;

    // Hierarchical greater-than detection:
    // Check MSB first; if different, decide result immediately
    // Else check next bit, etc.
    assign A_greater = (A[2] & ~B[2]) ? 1'b1 :
                       (~A[2] & B[2]) ? 1'b0 :
                       (A[1] & ~B[1]) ? 1'b1 :
                       (~A[1] & B[1]) ? 1'b0 :
                       (A[0] & ~B[0]) ? 1'b1 :
                       1'b0;

    // Less-than output by exclusion for mutual exclusivity
    assign A_less = ~A_equal & ~A_greater;

endmodule