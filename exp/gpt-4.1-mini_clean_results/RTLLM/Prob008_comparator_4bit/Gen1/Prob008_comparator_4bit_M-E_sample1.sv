module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Signals to track comparison at each bit
    wire gt3, eq3, lt3;
    wire gt2, eq2, lt2;
    wire gt1, eq1, lt1;
    wire gt0, eq0, lt0;

    // Compare bit 3 (MSB)
    assign gt3 = (A[3] & ~B[3]);
    assign lt3 = (~A[3] & B[3]);
    assign eq3 = ~(gt3 | lt3);

    // Compare bit 2
    assign gt2 = (A[2] & ~B[2]);
    assign lt2 = (~A[2] & B[2]);
    assign eq2 = ~(gt2 | lt2);

    // Compare bit 1
    assign gt1 = (A[1] & ~B[1]);
    assign lt1 = (~A[1] & B[1]);
    assign eq1 = ~(gt1 | lt1);

    // Compare bit 0 (LSB)
    assign gt0 = (A[0] & ~B[0]);
    assign lt0 = (~A[0] & B[0]);
    assign eq0 = ~(gt0 | lt0);

    // Determine overall comparison using priority from MSB to LSB
    assign A_greater = gt3 
                      | (eq3 & gt2) 
                      | (eq3 & eq2 & gt1) 
                      | (eq3 & eq2 & eq1 & gt0);

    assign A_less = lt3 
                   | (eq3 & lt2) 
                   | (eq3 & eq2 & lt1) 
                   | (eq3 & eq2 & eq1 & lt0);

    // Equal if all bits are equal
    assign A_equal = eq3 & eq2 & eq1 & eq0;

endmodule