module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate signals with descriptive names
    wire p1_abc_and = p1a & p1b & p1c;  // First 3-input AND for p1y
    wire p1_def_and = p1d & p1e & p1f;  // Second 3-input AND for p1y
    wire p2_ab_and = p2a & p2b;         // First 2-input AND for p2y
    wire p2_cd_and = p2c & p2d;         // Second 2-input AND for p2y

    // Output assignments with direct OR operations
    assign p1y = p1_abc_and | p1_def_and;
    assign p2y = p2_ab_and | p2_cd_and;
endmodule