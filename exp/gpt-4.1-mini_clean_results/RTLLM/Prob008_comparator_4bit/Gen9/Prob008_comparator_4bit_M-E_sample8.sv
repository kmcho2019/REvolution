module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit comparator signals
    wire [3:0] bit_greater; // A[i] > B[i]
    wire [3:0] bit_equal;   // A[i] == B[i]
    wire [3:0] bit_less;    // A[i] < B[i]

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : BIT_COMPARATOR
            assign bit_greater[i] =  A[i] & ~B[i];
            assign bit_equal[i]   = ~(A[i] ^ B[i]);
            assign bit_less[i]    = ~A[i] & B[i];
        end
    endgenerate

    // Determine if bits 3 down to (i+1) are all equal for each bit i
    wire eq_3_2 = bit_equal[3] & bit_equal[2];
    wire eq_3_2_1 = eq_3_2 & bit_equal[1];
    wire eq_3_2_1_0 = eq_3_2_1 & bit_equal[0];

    // Priority logic to decide overall comparison

    // A is greater if the highest bit where A and B differ has A[i] > B[i]
    wire a_greater_3 = bit_greater[3];
    wire a_greater_2 = bit_equal[3] & bit_greater[2];
    wire a_greater_1 = bit_equal[3] & bit_equal[2] & bit_greater[1];
    wire a_greater_0 = bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_greater[0];

    // A is less if the highest bit where A and B differ has A[i] < B[i]
    wire a_less_3 = bit_less[3];
    wire a_less_2 = bit_equal[3] & bit_less[2];
    wire a_less_1 = bit_equal[3] & bit_equal[2] & bit_less[1];
    wire a_less_0 = bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_less[0];

    assign A_greater = a_greater_3 | a_greater_2 | a_greater_1 | a_greater_0;
    assign A_less    = a_less_3 | a_less_2 | a_less_1 | a_less_0;
    assign A_equal   = eq_3_2_1_0; // all bits equal

endmodule