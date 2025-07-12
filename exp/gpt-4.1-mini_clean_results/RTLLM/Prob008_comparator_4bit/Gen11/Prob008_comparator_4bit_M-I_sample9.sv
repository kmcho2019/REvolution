module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Generate and propagate signals for borrow detection
    wire [3:0] generate_borrow; // borrow generate = (~A[i]) & B[i]
    wire [3:0] propagate_borrow; // borrow propagate = ~(A[i] ^ B[i])

    assign generate_borrow = (~A) & B;
    assign propagate_borrow = ~(A ^ B);

    // Calculate borrow signals in parallel (borrow[0] = 0)
    // borrow[1] = g0 + p0 * borrow[0]
    // borrow[2] = g1 + p1 * borrow[1]
    // borrow[3] = g2 + p2 * borrow[2]
    // borrow[4] = g3 + p3 * borrow[3]
    // Expand to avoid ripple:
    wire borrow_1 = generate_borrow[0];
    wire borrow_2 = generate_borrow[1] | (propagate_borrow[1] & generate_borrow[0]);
    wire borrow_3 = generate_borrow[2] | (propagate_borrow[2] & generate_borrow[1]) | (propagate_borrow[2] & propagate_borrow[1] & generate_borrow[0]);
    wire borrow_4 = generate_borrow[3] 
                    | (propagate_borrow[3] & generate_borrow[2]) 
                    | (propagate_borrow[3] & propagate_borrow[2] & generate_borrow[1]) 
                    | (propagate_borrow[3] & propagate_borrow[2] & propagate_borrow[1] & generate_borrow[0]);

    // Equality detection using balanced AND-tree of XNOR
    wire [3:0] bit_equal = ~(A ^ B);
    wire eq_01 = bit_equal[0] & bit_equal[1];
    wire eq_23 = bit_equal[2] & bit_equal[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs: mutually exclusive
    assign A_less    = borrow_4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_4 | equal_bits);

endmodule