module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       G,   // block generate
    output       P    // block propagate
);
    wire [3:0] p, g;
    wire [4:0] c;

    assign p = a ^ b;     // propagate bits
    assign g = a & b;     // generate bits
    assign c[0] = Cin;

    // Carry lookahead logic inside 4-bit block
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign y = p ^ c[3:0];  // sum bits

    // Block propagate and generate signals
    assign P = &p;          // propagate if all bits propagate
    assign G = g[3] | (p[3] & g[2]) | (p[3]&p[2] & g[1]) | (p[3]&p[2]&p[1] & g[0]);
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire [3:0] sum0, sum1, sum2, sum3;
    wire       G0, P0, G1, P1, G2, P2, G3, P3;
    wire [4:0] c;  // carry signals at block boundaries

    assign c[0] = Cin;

    // Instantiate 4-bit adders
    adder_4bit block0(.a(a[3:0]),   .b(b[3:0]),   .Cin(c[0]), .y(sum0), .G(G0), .P(P0));
    adder_4bit block1(.a(a[7:4]),   .b(b[7:4]),   .Cin(c[1]), .y(sum1), .G(G1), .P(P1));
    adder_4bit block2(.a(a[11:8]),  .b(b[11:8]),  .Cin(c[2]), .y(sum2), .G(G2), .P(P2));
    adder_4bit block3(.a(a[15:12]), .b(b[15:12]), .Cin(c[3]), .y(sum3), .G(G3), .P(P3));

    // Carry-lookahead for block carries
    assign c[1] = G0 | (P0 & c[0]);
    assign c[2] = G1 | (P1 & c[1]);
    assign c[3] = G2 | (P2 & c[2]);
    assign c[4] = G3 | (P3 & c[3]);

    // Assign outputs
    assign y = {sum3, sum2, sum1, sum0};
    assign Co = c[4];
endmodule