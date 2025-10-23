module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparisons between corresponding bits
    wire [2:0] gt_bits = (A & ~B);   // bits where A > B
    wire [2:0] lt_bits = (~A & B);   // bits where A < B
    wire [2:0] eq_bits = ~(A ^ B);   // bits where A == B (1 if equal, 0 if different)

    // Comparison outputs determined by priority from MSB to LSB
    assign A_greater = gt_bits[2] | 
                       (eq_bits[2] & gt_bits[1]) | 
                       (eq_bits[2] & eq_bits[1] & gt_bits[0]);

    assign A_less    = lt_bits[2] | 
                       (eq_bits[2] & lt_bits[1]) | 
                       (eq_bits[2] & eq_bits[1] & lt_bits[0]);

    assign A_equal   = &eq_bits; // all bits equal

endmodule