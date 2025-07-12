module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality for each bit: 1 if bits equal
    wire eq_bit [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : eq_gen
            assign eq_bit[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Borrow generate and propagate signals for subtractor logic:
    // g[i] = borrow generate: A[i] < B[i] (1 if borrow generated at bit i)
    // p[i] = borrow propagate: A[i] == B[i] (1 if borrow propagates through bit i)
    wire [3:0] g = (~A) & B;
    wire [3:0] p = {eq_bit[3], eq_bit[2], eq_bit[1], eq_bit[0]}; // propagate if equal bits

    // Balanced borrow lookahead:
    // borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
    wire g2p3     = g[2] & p[3];
    wire g1p2p3   = g[1] & p[2] & p[3];
    wire g0p1p2p3 = g[0] & p[1] & p[2] & p[3];
    wire borrow_out = g[3] | g2p3 | g1p2p3 | g0p1p2p3;

    // Balanced AND tree for equality detection (A == B)
    wire eq_01 = eq_bit[0] & eq_bit[1];
    wire eq_23 = eq_bit[2] & eq_bit[3];
    wire equal_bits = eq_01 & eq_23;

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule