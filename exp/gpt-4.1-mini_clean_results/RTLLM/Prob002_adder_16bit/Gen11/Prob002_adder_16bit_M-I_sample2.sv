module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout,
    output       P,    // Group propagate
    output       G     // Group generate
);
    wire [7:0] p;    // propagate signals per bit
    wire [7:0] g;    // generate signals per bit
    wire [8:0] c;    // carries

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_calc
            assign c[i+1] = g[i] | (p[i] & c[i]);
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign Cout = c[8];

    // Group propagate: all bits propagate
    assign P = &p; // AND of all p bits
    // Group generate: generate from MSB or propagated generate from lower bits
    // G = g7 + p7*g6 + p7*p6*g5 + ... + p7*p6*p5*p4*p3*p2*p1*g0
    // Simplified by carry-out logic: G = Cout when Cin=0 but we compute explicitly:
    // Using ripple form:
    wire g0_p1, g1_p2, g2_p3, g3_p4, g4_p5, g5_p6, g6_p7;
    assign g0_p1 = g[0];
    assign g1_p2 = g[1] | (p[1] & g0_p1);
    assign g2_p3 = g[2] | (p[2] & g1_p2);
    assign g3_p4 = g[3] | (p[3] & g2_p3);
    assign g4_p5 = g[4] | (p[4] & g3_p4);
    assign g5_p6 = g[5] | (p[5] & g4_p5);
    assign g6_p7 = g[6] | (p[6] & g5_p6);
    assign G     = g[7] | (p[7] & g6_p7);
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;
    wire P_lower, G_lower;
    wire P_upper, G_upper;
    wire carry_in_upper;

    // Lower 8-bit adder with group P/G outputs
    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid),
        .P(P_lower),
        .G(G_lower)
    );

    // Compute carry-in for upper adder using carry-lookahead between 8-bit blocks
    assign carry_in_upper = G_lower | (P_lower & Cin);

    // Upper 8-bit adder with group P/G outputs (P_upper, G_upper not used here but output for completeness)
    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_in_upper),
        .sum(y[15:8]),
        .Cout(Co),
        .P(P_upper),
        .G(G_upper)
    );
endmodule