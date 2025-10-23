module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P,  // group propagate
    output       G   // group generate
);
    wire [4:1] p, g;
    wire [4:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i=1; i<=4; i=i+1) begin : pg_loop
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead logic for 4-bit block:
    // c[1] = g[1] | p[1]&c[0]
    // c[2] = g[2] | p[2]&g[1] | p[2]&p[1]&c[0]
    // c[3] = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&c[0]
    // c[4] = g[4] | p[4]&g[3] | p[4]&p[3]&g[2] | p[4]&p[3]&p[2]&g[1] | p[4]&p[3]&p[2]&p[1]&c[0]

    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & c[0]);
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & c[0]);

    generate
        for (i=1; i<=4; i=i+1) begin : sum_loop
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate: all p bits propagate
    assign P = &p[4:1];

    // Group generate: g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1
    assign G = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);

    assign Cout = c[4];
endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,  // group propagate of 16-bit block
    output        G   // group generate of 16-bit block
);
    wire [3:0] p_sub, g_sub; // group propagate/generate from 4-bit blocks
    wire [4:0] c_sub; // carries between 4-bit blocks (c_sub[0] = Cin)

    assign c_sub[0] = Cin;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : four_bit_blocks
            cla_4bit cla4 (
                .A   (A[4*i+4:4*i+1]),
                .B   (B[4*i+4:4*i+1]),
                .Cin (c_sub[i]),
                .S   (S[4*i+4:4*i+1]),
                .Cout(),
                .P   (p_sub[i]),
                .G   (g_sub[i])
            );
        end
    endgenerate

    // Compute carry into each 4-bit block after the first, using CLA formula on 4-bit groups:
    // c_sub[1] = g_sub[0] | (p_sub[0] & c_sub[0])
    // c_sub[2] = g_sub[1] | (p_sub[1] & g_sub[0]) | (p_sub[1] & p_sub[0] & c_sub[0])
    // c_sub[3] = g_sub[2] | (p_sub[2] & g_sub[1]) | (p_sub[2] & p_sub[1] & g_sub[0]) | (p_sub[2] & p_sub[1] & p_sub[0] & c_sub[0])
    // c_sub[4] = g_sub[3] | (p_sub[3] & g_sub[2]) | (p_sub[3] & p_sub[2] & g_sub[1]) | (p_sub[3] & p_sub[2] & p_sub[1] & g_sub[0]) | (p_sub[3] & p_sub[2] & p_sub[1] & p_sub[0] & c_sub[0])

    assign c_sub[1] = g_sub[0] | (p_sub[0] & c_sub[0]);
    assign c_sub[2] = g_sub[1] | (p_sub[1] & g_sub[0]) | (p_sub[1] & p_sub[0] & c_sub[0]);
    assign c_sub[3] = g_sub[2] | (p_sub[2] & g_sub[1]) | (p_sub[2] & p_sub[1] & g_sub[0]) | (p_sub[2] & p_sub[1] & p_sub[0] & c_sub[0]);
    assign c_sub[4] = g_sub[3] | (p_sub[3] & g_sub[2]) | (p_sub[3] & p_sub[2] & g_sub[1]) | (p_sub[3] & p_sub[2] & p_sub[1] & g_sub[0]) | (p_sub[3] & p_sub[2] & p_sub[1] & p_sub[0] & c_sub[0]);

    assign Cout = c_sub[4];

    // Group propagate of 16-bit block is AND of all 4 p_sub
    assign P = &p_sub;

    // Group generate of 16-bit block is CLA formula on groups
    assign G = g_sub[3] | (p_sub[3] & g_sub[2]) | (p_sub[3] & p_sub[2] & g_sub[1]) | (p_sub[3] & p_sub[2] & p_sub[1] & g_sub[0]);
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0;
    wire P1, G1;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P1),
        .G   (G1)
    );
endmodule