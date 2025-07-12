module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit Carry Lookahead Adder Block
module cla_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       P, // block propagate
    output wire       G  // block generate
);
    wire [3:0] p; // propagate for each bit
    wire [3:0] g; // generate for each bit
    wire [3:1] c; // internal carries

    // Generate propagate and generate for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign cout = g[3] | (p[3] & c[3]);

    // Sum calculation
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];

    // Block propagate and generate signals
    assign P = &p; // All propagate bits must be 1 for block propagate
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

// Top-level 16-bit adder using four 4-bit CLA blocks
module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire [3:0] sum0, sum1, sum2, sum3;
    wire       c1, c2, c3, c4;
    wire       P0, P1, P2, P3;
    wire       G0, G1, G2, G3;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (.a(a[3:0]),   .b(b[3:0]),   .cin(Cin),  .sum(sum0), .cout(),   .P(P0), .G(G0));
    cla_4bit cla1 (.a(a[7:4]),   .b(b[7:4]),   .cin(c1),   .sum(sum1), .cout(),   .P(P1), .G(G1));
    cla_4bit cla2 (.a(a[11:8]),  .b(b[11:8]),  .cin(c2),   .sum(sum2), .cout(),   .P(P2), .G(G2));
    cla_4bit cla3 (.a(a[15:12]), .b(b[15:12]), .cin(c3),   .sum(sum3), .cout(),   .P(P3), .G(G3));

    // Top-level carry lookahead for block carries
    assign c1 = G0 | (P0 & Cin);
    assign c2 = G1 | (P1 & c1);
    assign c3 = G2 | (P2 & c2);
    assign c4 = G3 | (P3 & c3);

    // Concatenate sum outputs
    assign y = {sum3, sum2, sum1, sum0};
    assign Co = c4;
endmodule