module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bit equality using XNOR for clarity
    wire [3:0] eq_bit;
    assign eq_bit = ~(A ^ B);

    // Borrow generate (g) and propagate (p) per bit:
    // g[i] = 1 if borrow generated at bit i (A[i]<B[i])
    // p[i] = 1 if borrow propagates through bit i (A[i]==B[i])
    wire [3:0] g = (~A) & B;
    wire [3:0] p = eq_bit;

    // Carry-lookahead style borrow signals:
    // borrow_in[0] is borrow into bit 0 (assumed 0)
    wire borrow_in_0 = 1'b0;
    wire borrow_in_1 = g[0] | (p[0] & borrow_in_0);
    wire borrow_in_2 = g[1] | (p[1] & borrow_in_1);
    wire borrow_in_3 = g[2] | (p[2] & borrow_in_2);

    // borrow_out is borrow out of MSB (bit 3)
    wire borrow_out = g[3] | (p[3] & borrow_in_3);

    // Equality detection by ANDing all eq_bit signals
    wire all_equal = &eq_bit;

    assign A_less    = borrow_out;
    assign A_equal   = all_equal;
    assign A_greater = ~borrow_out & ~all_equal;

endmodule