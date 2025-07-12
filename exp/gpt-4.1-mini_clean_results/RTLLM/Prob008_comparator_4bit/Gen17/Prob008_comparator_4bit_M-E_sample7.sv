module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    // Internal signals for each bit comparator result:
    // greater[i] = 1 if at bit i, A[i] > B[i]
    // less[i]    = 1 if at bit i, A[i] < B[i]
    // equal[i]   = 1 if A[i] == B[i]
    wire [3:0] greater;
    wire [3:0] less;
    wire [3:0] equal;

    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : bit_compare
            assign greater[i] = A[i] & ~B[i];
            assign less[i]    = ~A[i] & B[i];
            assign equal[i]   = ~(greater[i] | less[i]); // A[i] == B[i]
        end
    endgenerate

    // Decision signals generated from MSB to LSB:
    // At each bit, if greater or less is set, that's the final decision.
    // Otherwise, continue to next bit.

    // Intermediate signals to propagate decision down the bits
    wire greater_decision;
    wire less_decision;
    wire equal_all;

    // Using a priority chain from bit 3 down to 0:
    // g3, l3 have highest priority, then g2,l2, etc.
    wire comp3_greater = greater[3];
    wire comp3_less    = less[3];
    wire comp3_equal   = equal[3];

    wire comp2_greater = greater[2];
    wire comp2_less    = less[2];
    wire comp2_equal   = equal[2];

    wire comp1_greater = greater[1];
    wire comp1_less    = less[1];
    wire comp1_equal   = equal[1];

    wire comp0_greater = greater[0];
    wire comp0_less    = less[0];
    wire comp0_equal   = equal[0];

    // Combine logic: find first non-equal bit from MSB downward
    // greater_decision = 
    //   if bit3 greater else if bit3 equal and bit2 greater else if bit3 & bit2 equal and bit1 greater else if bit3 & bit2 & bit1 equal and bit0 greater else 0
    assign greater_decision =
           comp3_greater
        | (comp3_equal & comp2_greater)
        | (comp3_equal & comp2_equal & comp1_greater)
        | (comp3_equal & comp2_equal & comp1_equal & comp0_greater);

    // Similarly for less_decision:
    assign less_decision =
           comp3_less
        | (comp3_equal & comp2_less)
        | (comp3_equal & comp2_equal & comp1_less)
        | (comp3_equal & comp2_equal & comp1_equal & comp0_less);

    // Equal if all bits equal
    assign equal_all = comp3_equal & comp2_equal & comp1_equal & comp0_equal;

    // Assign outputs
    assign A_greater = greater_decision;
    assign A_less    = less_decision;
    assign A_equal   = equal_all;

endmodule