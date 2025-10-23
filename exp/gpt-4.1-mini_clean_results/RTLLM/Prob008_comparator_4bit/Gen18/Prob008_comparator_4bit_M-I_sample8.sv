module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] eq_bit;     // Equality bits per position (1 if bits equal)
    wire [3:0] g;          // Generate borrow signals (1 if A[i]<B[i])
    wire [3:0] p;          // Propagate borrow signals (1 if bits equal)

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bits_compare
            assign eq_bit[i] = (A[i] ~^ B[i]);
            assign g[i]      = (~A[i]) & B[i];
            assign p[i]      = eq_bit[i];
        end
    endgenerate

    // Compute borrow_out using a simple prefix OR of generate and propagate terms:
    // borrow_out = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0])
    wire borrow_out;
    wire p3_g2    = p[3] & g[2];
    wire p3_p2_g1 = p[3] & p[2] & g[1];
    wire p3_p2_p1_g0 = p[3] & p[2] & p[1] & g[0];

    assign borrow_out = g[3] | p3_g2 | p3_p2_g1 | p3_p2_p1_g0;

    // Equality: all bits equal if all eq_bit are 1; use reduction AND
    wire equal_bits = &eq_bit;

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule