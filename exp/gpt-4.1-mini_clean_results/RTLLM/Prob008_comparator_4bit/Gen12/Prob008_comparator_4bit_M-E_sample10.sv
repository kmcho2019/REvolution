module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit comparison signals: bitwise equality and bitwise greater/less
    wire [3:0] bit_equal;
    wire [3:0] bit_A_greater;
    wire [3:0] bit_A_less;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : bit_compare
            assign bit_equal[i]     = (A[i] == B[i]);
            assign bit_A_greater[i] = (A[i] & ~B[i]);
            assign bit_A_less[i]    = (~A[i] & B[i]);
        end
    endgenerate

    // Comparison chain logic from MSB to LSB
    // Start checking at MSB down to LSB; the first bit where A and B differ determines output
    // If all bits equal, then A_equal = 1
    // Otherwise, output from first differing bit signals A_greater or A_less.

    wire bit3_decided, bit2_decided, bit1_decided, bit0_decided;
    wire bit3_gt, bit2_gt, bit1_gt, bit0_gt;
    wire bit3_lt, bit2_lt, bit1_lt, bit0_lt;

    // MSB
    assign bit3_decided = ~bit_equal[3];
    assign bit3_gt = bit_A_greater[3];
    assign bit3_lt = bit_A_less[3];

    // Next bit considered only if previous bits equal
    assign bit2_decided = (~bit_equal[3]) ? 1'b0 : ~bit_equal[2];
    assign bit2_gt = bit_A_greater[2];
    assign bit2_lt = bit_A_less[2];

    assign bit1_decided = (~bit_equal[3] | ~bit_equal[2]) ? 1'b0 : ~bit_equal[1];
    assign bit1_gt = bit_A_greater[1];
    assign bit1_lt = bit_A_less[1];

    assign bit0_decided = (~bit_equal[3] | ~bit_equal[2] | ~bit_equal[1]) ? 1'b0 : ~bit_equal[0];
    assign bit0_gt = bit_A_greater[0];
    assign bit0_lt = bit_A_less[0];

    // Combine to determine A_greater and A_less
    assign A_greater = (bit3_decided & bit3_gt) |
                       (~bit_equal[3] & ~bit3_gt & bit3_lt ? 1'b0 : 1'b0) | // No else needed, handled below
                       ((~bit_equal[3]) ? 1'b0 : 
                         (bit2_decided & bit2_gt) |
                         ((~bit_equal[2]) ? 1'b0 :
                           (bit1_decided & bit1_gt) |
                           ((~bit_equal[1]) ? 1'b0 :
                             (bit0_decided & bit0_gt)
                           )
                         )
                       );

    assign A_less = (bit3_decided & bit3_lt) |
                    ((~bit_equal[3]) ? 1'b0 : 
                      (bit2_decided & bit2_lt) |
                      ((~bit_equal[2]) ? 1'b0 :
                        (bit1_decided & bit1_lt) |
                        ((~bit_equal[1]) ? 1'b0 :
                          (bit0_decided & bit0_lt)
                        )
                      )
                    );

    // Equality: all bits equal
    assign A_equal = bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_equal[0];

endmodule