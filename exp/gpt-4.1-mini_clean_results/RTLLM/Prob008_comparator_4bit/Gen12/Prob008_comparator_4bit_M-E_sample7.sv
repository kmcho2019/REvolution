module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal signals for each bit comparator stage:
    // Each stage produces flags: greater_i, equal_i, less_i

    // Bit 0 comparison
    wire greater_0 = (A[0] & ~B[0]);
    wire less_0    = (~A[0] & B[0]);
    wire equal_0   = ~(greater_0 | less_0); // A[0] == B[0]

    // Bit 1 comparison combined with lower bit
    wire greater_1 = (A[1] & ~B[1]) | (equal_1 & greater_0);
    wire less_1    = (~A[1] & B[1]) | (equal_1 & less_0);
    wire equal_1   = ( (A[1] == B[1]) && equal_0 );

    // Bit 2 comparison combined with lower bits
    wire greater_2 = (A[2] & ~B[2]) | (equal_2 & greater_1);
    wire less_2    = (~A[2] & B[2]) | (equal_2 & less_1);
    wire equal_2   = ( (A[2] == B[2]) && equal_1 );

    // Bit 3 comparison combined with lower bits
    wire greater_3 = (A[3] & ~B[3]) | (equal_3 & greater_2);
    wire less_3    = (~A[3] & B[3]) | (equal_3 & less_2);
    wire equal_3   = ( (A[3] == B[3]) && equal_2 );

    // To break circular dependency, note equal_i signals depend on bit equalities and previous equal_(i-1).
    // So define equals bitwise first:
    wire eq0 = (A[0] == B[0]);
    wire eq1 = (A[1] == B[1]);
    wire eq2 = (A[2] == B[2]);
    wire eq3 = (A[3] == B[3]);

    // Recalculate equal signals properly:
    wire equal_0_final = eq0;
    wire equal_1_final = eq1 & equal_0_final;
    wire equal_2_final = eq2 & equal_1_final;
    wire equal_3_final = eq3 & equal_2_final;

    // Now recalculate greater and less at each level using updated equals:
    wire greater_0_final = (A[0] & ~B[0]);
    wire less_0_final    = (~A[0] & B[0]);

    wire greater_1_final = (A[1] & ~B[1]) | (equal_1_final & greater_0_final);
    wire less_1_final    = (~A[1] & B[1]) | (equal_1_final & less_0_final);

    wire greater_2_final = (A[2] & ~B[2]) | (equal_2_final & greater_1_final);
    wire less_2_final    = (~A[2] & B[2]) | (equal_2_final & less_1_final);

    wire greater_3_final = (A[3] & ~B[3]) | (equal_3_final & greater_2_final);
    wire less_3_final    = (~A[3] & B[3]) | (equal_3_final & less_2_final);

    // Assign final outputs from the MSB comparator stage
    assign A_greater = greater_3_final;
    assign A_less    = less_3_final;
    assign A_equal   = equal_3_final;

endmodule