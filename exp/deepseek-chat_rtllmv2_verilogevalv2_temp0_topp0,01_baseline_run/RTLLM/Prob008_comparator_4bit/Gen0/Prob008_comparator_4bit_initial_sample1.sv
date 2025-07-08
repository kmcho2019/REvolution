module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire gt3, eq3, lt3;  // MSB comparison results
    wire gt2, eq2, lt2;
    wire gt1, eq1, lt1;
    wire gt0, eq0, lt0;  // LSB comparison results

    // Bit-wise comparison
    assign gt3 = (A[3] > B[3]);
    assign eq3 = (A[3] == B[3]);
    assign lt3 = (A[3] < B[3]);

    assign gt2 = (A[2] > B[2]);
    assign eq2 = (A[2] == B[2]);
    assign lt2 = (A[2] < B[2]);

    assign gt1 = (A[1] > B[1]);
    assign eq1 = (A[1] == B[1]);
    assign lt1 = (A[1] < B[1]);

    assign gt0 = (A[0] > B[0]);
    assign eq0 = (A[0] == B[0]);
    assign lt0 = (A[0] < B[0]);

    // Hierarchical comparison logic
    assign A_greater = gt3 | (eq3 & gt2) | (eq3 & eq2 & gt1) | (eq3 & eq2 & eq1 & gt0);
    assign A_equal = eq3 & eq2 & eq1 & eq0;
    assign A_less = lt3 | (eq3 & lt2) | (eq3 & eq2 & lt1) | (eq3 & eq2 & eq1 & lt0);

endmodule