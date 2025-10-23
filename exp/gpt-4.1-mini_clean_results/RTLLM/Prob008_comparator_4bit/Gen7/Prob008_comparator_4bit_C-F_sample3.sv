module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] eq_bits; // per bit equality (A[i] == B[i])
    wire [3:0] g;       // borrow generate signals
    wire [3:0] p;       // borrow propagate signals
    wire       borrow_out;
    wire       all_equal;

    genvar i;

    // Generate per-bit equality signals (XNOR)
    generate
        for (i = 0; i < 4; i = i + 1) begin : EQ_GEN
            assign eq_bits[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Borrow generate and propagate signals using standard borrow logic:
    // g[i] = (~A[i] & B[i]) -- borrow generated if A[i] < B[i]
    // p[i] = eq_bits[i]     -- borrow propagates if bits equal (A[i] == B[i])
    generate
        for (i = 0; i < 4; i = i + 1) begin : GP_GEN
            assign g[i] = (~A[i]) & B[i];
            assign p[i] = eq_bits[i];
        end
    endgenerate

    // Borrow lookahead logic (borrow out of MSB):
    // borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
    assign borrow_out = g[3]
                      | (p[3] & g[2])
                      | (p[3] & p[2] & g[1])
                      | (p[3] & p[2] & p[1] & g[0]);

    // Equality: all bits equal if all eq_bits are 1
    assign all_equal = &eq_bits;

    // Outputs: mutually exclusive
    assign A_less    = borrow_out;
    assign A_equal   = all_equal;
    assign A_greater = ~(borrow_out | all_equal);

endmodule