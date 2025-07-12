module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit comparison signals:
    // For each bit i, define if A[i] > B[i], A[i] == B[i], or A[i] < B[i]
    wire [3:0] bit_gt = (A & ~B);  // A[i]=1, B[i]=0 => A > B at bit i
    wire [3:0] bit_lt = (~A & B);  // A[i]=0, B[i]=1 => A < B at bit i
    wire [3:0] bit_eq = ~(A ^ B);  // A[i] == B[i]

    // Priority encoder from MSB to LSB to decide overall comparison:
    // If MSB differs, that decides, else check next bit, ...
    wire greater_hierarchy;
    wire less_hierarchy;
    wire equal_hierarchy;

    assign greater_hierarchy = bit_gt[3] ? 1'b1 :
                              (bit_eq[3] & bit_gt[2]) ? 1'b1 :
                              (bit_eq[3] & bit_eq[2] & bit_gt[1]) ? 1'b1 :
                              (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]) ? 1'b1 : 1'b0;

    assign less_hierarchy = bit_lt[3] ? 1'b1 :
                           (bit_eq[3] & bit_lt[2]) ? 1'b1 :
                           (bit_eq[3] & bit_eq[2] & bit_lt[1]) ? 1'b1 :
                           (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_lt[0]) ? 1'b1 : 1'b0;

    assign equal_hierarchy = &bit_eq;  // all bits equal

    // Assign mutually exclusive outputs
    assign A_greater = greater_hierarchy;
    assign A_less    = less_hierarchy;
    assign A_equal   = equal_hierarchy;

endmodule