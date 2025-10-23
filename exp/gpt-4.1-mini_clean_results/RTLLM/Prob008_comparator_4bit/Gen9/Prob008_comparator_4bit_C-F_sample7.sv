module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate vector: g[i] = ~A[i] & B[i]
    wire [3:0] g = (~A) & B;
    // Borrow propagate vector: p[i] = ~(A[i] ^ B[i])  (bit equality)
    wire [3:0] p = ~(A ^ B);

    // Compute intermediate borrow signals explicitly (borrow chain)
    wire borrow_1 = g[0];
    wire borrow_2 = g[1] | (p[1] & borrow_1);
    wire borrow_3 = g[2] | (p[2] & borrow_2);
    wire borrow_4 = g[3] | (p[3] & borrow_3); // final borrow out

    // Equality: all bits equal if all p bits are 1 (XNOR reduction)
    wire equal_bits = &p;

    assign A_less    = borrow_4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_4 | equal_bits);

endmodule