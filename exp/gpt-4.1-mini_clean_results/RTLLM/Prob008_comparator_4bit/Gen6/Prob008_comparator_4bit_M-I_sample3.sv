module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Generate (g) and propagate (p) signals for borrow calculation
    wire [3:0] g; // generate borrow if ~A & B
    wire [3:0] p; // propagate borrow if bits equal

    assign g = (~A) & B;
    assign p = ~(A ^ B);

    // Parallel borrow out for MSB without ripple chain
    wire borrow3 = g[3]
                 | (p[3] & g[2])
                 | (p[3] & p[2] & g[1])
                 | (p[3] & p[2] & p[1] & g[0]);

    // Equality check by bitwise XNOR and reduction AND
    wire eq_bits = &(~(A ^ B));

    // Outputs are mutually exclusive:
    // borrow3 = 1 means A < B
    // borrow3 = 0 & eq_bits = 1 means A == B
    // borrow3 = 0 & eq_bits = 0 means A > B
    assign A_less    = borrow3;
    assign A_equal   = (~borrow3) & eq_bits;
    assign A_greater = (~borrow3) & (~eq_bits);

endmodule