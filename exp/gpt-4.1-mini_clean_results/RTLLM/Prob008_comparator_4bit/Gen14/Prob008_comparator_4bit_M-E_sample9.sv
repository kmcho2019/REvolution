module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per bit comparison signals
    wire gt3 = (A[3] & ~B[3]);
    wire eq3 = ~(A[3] ^ B[3]);
    wire lt3 = (~A[3] & B[3]);

    wire gt2 = (A[2] & ~B[2]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire lt2 = (~A[2] & B[2]);

    wire gt1 = (A[1] & ~B[1]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire lt1 = (~A[1] & B[1]);

    wire gt0 = (A[0] & ~B[0]);
    wire eq0 = ~(A[0] ^ B[0]);
    wire lt0 = (~A[0] & B[0]);

    // Compose the final comparison outputs hierarchically:
    // A > B if (bit3 greater) OR (bit3 equal AND bit2 greater) OR (bit3&2 equal AND bit1 greater) OR (bit3&2&1 equal AND bit0 greater)
    assign A_greater = gt3 
                     | (eq3 & gt2) 
                     | (eq3 & eq2 & gt1) 
                     | (eq3 & eq2 & eq1 & gt0);

    // A < B if (bit3 less) OR (bit3 equal AND bit2 less) OR (bit3&2 equal AND bit1 less) OR (bit3&2&1 equal AND bit0 less)
    assign A_less = lt3 
                  | (eq3 & lt2) 
                  | (eq3 & eq2 & lt1) 
                  | (eq3 & eq2 & eq1 & lt0);

    // A equal B if all bits equal
    assign A_equal = eq3 & eq2 & eq1 & eq0;

endmodule