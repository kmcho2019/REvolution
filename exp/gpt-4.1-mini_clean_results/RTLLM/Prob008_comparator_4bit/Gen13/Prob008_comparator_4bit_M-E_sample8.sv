module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise XNOR for equality per bit
    wire [3:0] eq_bits = ~(A ^ B);

    // Equality is AND of all eq_bits
    wire equal_all = &eq_bits;

    // Bitwise comparison from MSB to LSB
    // Determine where A > B or A < B by scanning bits from MSB to LSB

    wire gt3 =  A[3] & ~B[3];
    wire lt3 = ~A[3] &  B[3];

    wire gt2 =  A[2] & ~B[2];
    wire lt2 = ~A[2] &  B[2];

    wire gt1 =  A[1] & ~B[1];
    wire lt1 = ~A[1] &  B[1];

    wire gt0 =  A[0] & ~B[0];
    wire lt0 = ~A[0] &  B[0];

    // Determine if A > B
    // Priority: check MSB first; if equal go to next bit
    wire A_greater_internal =
         gt3 |
        (~(gt3 | lt3) & gt2) |
        (~(gt3 | lt3 | gt2 | lt2) & gt1) |
        (~(gt3 | lt3 | gt2 | lt2 | gt1 | lt1) & gt0);

    // Determine if A < B
    wire A_less_internal =
         lt3 |
        (~(gt3 | lt3) & lt2) |
        (~(gt3 | lt3 | gt2 | lt2) & lt1) |
        (~(gt3 | lt3 | gt2 | lt2 | gt1 | lt1) & lt0);

    // Outputs are mutually exclusive, equal if none of greater or less
    assign A_greater = A_greater_internal;
    assign A_less    = A_less_internal;
    assign A_equal   = equal_all;

endmodule