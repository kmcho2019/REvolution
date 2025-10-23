module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Equality detection using built-in operator for clarity and minimal logic
    assign A_equal = (A == B);

    // Hierarchical greater-than detection from MSB to LSB
    assign A_greater = (A[2] & ~B[2]) ? 1'b1 :
                       ((A[2] == B[2]) && (A[1] & ~B[1])) ? 1'b1 :
                       ((A[2] == B[2]) && (A[1] == B[1]) && (A[0] & ~B[0])) ? 1'b1 :
                       1'b0;

    // Less-than derived by exclusion to ensure mutual exclusivity
    assign A_less = ~A_equal & ~A_greater;

endmodule