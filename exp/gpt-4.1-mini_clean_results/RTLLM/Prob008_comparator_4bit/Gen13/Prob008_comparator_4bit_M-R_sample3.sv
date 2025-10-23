module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compute bitwise equality vector: 1 for each bit where A[i]==B[i]
    wire [3:0] eq_bits = ~(A ^ B);

    // Borrow generate (g) and propagate (p) signals:
    // g[i]: borrow generated when A[i] < B[i]
    // p[i]: borrow propagates if bits equal (A[i]==B[i])
    wire [3:0] g = (~A) & B;
    wire [3:0] p = eq_bits;

    // Borrow lookahead logic:
    // borrow_out = g[3] |
    //              (p[3] & g[2]) |
    //              (p[3] & p[2] & g[1]) |
    //              (p[3] & p[2] & p[1] & g[0])
    wire borrow_out =
          g[3]
        | (p[3] & g[2])
        | (p[3] & p[2] & g[1])
        | (p[3] & p[2] & p[1] & g[0]);

    // Equality is true only if all bits equal
    wire equal_all = &eq_bits;

    // Outputs: mutually exclusive by definition
    assign A_less    = borrow_out;
    assign A_equal   = equal_all;
    assign A_greater = ~borrow_out & ~equal_all;

endmodule