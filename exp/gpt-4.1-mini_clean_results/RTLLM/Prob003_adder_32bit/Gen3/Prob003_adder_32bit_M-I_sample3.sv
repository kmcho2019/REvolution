// 4-bit CLA block: compute sum, carry-out, block propagate and generate
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P,  // block propagate
    output       G   // block generate
);
    wire [4:1] p, g;
    wire [4:0] c;
    assign c[0] = Cin;

    genvar i;
    generate
        for(i=1; i<=4; i=i+1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead for 4-bit block
    // c[1] = g[1] | p[1]&c[0]
    // c[2] = g[2] | p[2]&g[1] | p[2]&p[1]&c[0]
    // c[3] = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&c[0]
    // c[4] = g[4] | p[4]&g[3] | p[4]&p[3]&g[2] | p[4]&p[3]&p[2]&g[1] | p[4]&p[3]&p[2]&p[1]&c[0]

    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2]&p[1] & c[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1] & c[0]);
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4]&p[3]&g[2]) | (p[4]&p[3]&p[2]&g[1]) | (p[4]&p[3]&p[2]&p[1] & c[0]);

    // Sum bits
    generate
        for(i=1; i<=4; i=i+1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign Cout = c[4];

    // Block propagate = all propagate bits are 1
    assign P = &p[4:1];

    // Block generate = G4 plus P4 times G3 plus ... expanded above is simply c[4] when Cin=0
    wire [4:0] c0;
    assign c0[0] = 1'b0;
    assign c0[1] = g[1] | (p[1] & c0[0]);
    assign c0[2] = g[2] | (p[2] & g[1]) | (p[2]&p[1] & c0[0]);
    assign c0[3] = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1] & c0[0]);
    assign c0[4] = g[4] | (p[4] & g[3]) | (p[4]&p[3]&g[2]) | (p[4]&p[3]&p[2]&g[1]) | (p[4]&p[3]&p[2]&p[1] & c0[0]);

    assign G = c0[4];
endmodule


// 16-bit CLA block built from four 4-bit CLA groups and a 4-bit carry lookahead generator on groups
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,  // block propagate
    output        G   // block generate
);
    wire [3:0] p_grp, g_grp;   // group propagate/generate signals for each 4-bit group
    wire [4:0] c_grp;          // group carries
    assign c_grp[0] = Cin;

    genvar gi;

    // Instantiate 4-bit CLA for each group
    generate
        for(gi=0; gi<4; gi=gi+1) begin : gen_4bit_cla_groups
            cla_4bit cla4 (
                .A(A[4*gi+4:4*gi+1]),
                .B(B[4*gi+4:4*gi+1]),
                .Cin(c_grp[gi]),
                .S(S[4*gi+4:4*gi+1]),
                .Cout(),
                .P(p_grp[gi+1]),
                .G(g_grp[gi+1])
            );
        end
    endgenerate

    // 4-bit carry lookahead on groups to generate carries c_grp[1..4]
    // Similar to cla_4bit carry logic but on group p,g
    assign c_grp[1] = g_grp[1] | (p_grp[1] & c_grp[0]);
    assign c_grp[2] = g_grp[2] | (p_grp[2] & g_grp[1]) | (p_grp[2]&p_grp[1] & c_grp[0]);
    assign c_grp[3] = g_grp[3] | (p_grp[3] & g_grp[2]) | (p_grp[3]&p_grp[2]&g_grp[1]) | (p_grp[3]&p_grp[2]&p_grp[1] & c_grp[0]);
    assign c_grp[4] = g_grp[4] | (p_grp[4] & g_grp[3]) | (p_grp[4]&p_grp[3]&g_grp[2]) | (p_grp[4]&p_grp[3]&p_grp[2]&g_grp[1]) | (p_grp[4]&p_grp[3]&p_grp[2]&p_grp[1] & c_grp[0]);

    assign Cout = c_grp[4];
    assign P = &p_grp[4:1];
    // Block generate G equals to the group carry-out with Cin=0
    // Compute G when Cin=0 by recomputing c_grp with c_grp[0]=0
    wire [4:0] c0;
    assign c0[0] = 1'b0;
    assign c0[1] = g_grp[1] | (p_grp[1] & c0[0]);
    assign c0[2] = g_grp[2] | (p_grp[2] & g_grp[1]) | (p_grp[2]&p_grp[1] & c0[0]);
    assign c0[3] = g_grp[3] | (p_grp[3] & g_grp[2]) | (p_grp[3]&p_grp[2]&g_grp[1]) | (p_grp[3]&p_grp[2]&p_grp[1] & c0[0]);
    assign c0[4] = g_grp[4] | (p_grp[4] & g_grp[3]) | (p_grp[4]&p_grp[3]&g_grp[2]) | (p_grp[4]&p_grp[3]&p_grp[2]&g_grp[1]) | (p_grp[4]&p_grp[3]&p_grp[2]&p_grp[1] & c0[0]);

    assign G = c0[4];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire P0, G0;    // Propagate and generate of lower 16-bit block
    wire P1, G1;    // Propagate and generate of upper 16-bit block
    wire C16;       // Carry out of lower 16-bit block (carry into upper)

    // Lower 16-bit CLA (bits 1 to 16)
    cla_16bit cla_lo(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .P(P0),
        .G(G0)
    );

    // Carry into upper block
    // Carry-in to upper block = G0 + P0 * 0 = G0 (since carry-in=0)
    wire Cin_hi = G0 | (P0 & 1'b0); // simplified to G0

    // Upper 16-bit CLA (bits 17 to 32)
    cla_16bit cla_hi(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cin_hi),
        .S(S[32:17]),
        .Cout(C32),
        .P(P1),
        .G(G1)
    );
endmodule