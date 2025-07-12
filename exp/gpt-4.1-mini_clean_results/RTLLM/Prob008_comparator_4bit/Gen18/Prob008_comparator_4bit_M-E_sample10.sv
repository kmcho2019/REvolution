module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality for each bit
    wire eq3 = (A[3] == B[3]);
    wire eq2 = (A[2] == B[2]);
    wire eq1 = (A[1] == B[1]);
    wire eq0 = (A[0] == B[0]);

    // Greater comparison for each bit
    wire gt3 = (A[3] & ~B[3]);
    wire gt2 = (A[2] & ~B[2]);
    wire gt1 = (A[1] & ~B[1]);
    wire gt0 = (A[0] & ~B[0]);

    // Less comparison for each bit
    wire lt3 = (~A[3] & B[3]);
    wire lt2 = (~A[2] & B[2]);
    wire lt1 = (~A[1] & B[1]);
    wire lt0 = (~A[0] & B[0]);

    // Determine A_greater by checking bits from MSB down, only if higher bits are equal
    wire A_greater_bit = gt3
                      | (eq3 & gt2)
                      | (eq3 & eq2 & gt1)
                      | (eq3 & eq2 & eq1 & gt0);

    // Determine A_less similarly
    wire A_less_bit = lt3
                   | (eq3 & lt2)
                   | (eq3 & eq2 & lt1)
                   | (eq3 & eq2 & eq1 & lt0);

    // Determine equality by AND of all equal bits
    wire A_equal_bit = eq3 & eq2 & eq1 & eq0;

    assign A_greater = A_greater_bit;
    assign A_less    = A_less_bit;
    assign A_equal   = A_equal_bit;

endmodule