module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P,  // Group propagate
    output       G   // Group generate
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

    // Carry computation by direct CLA logic
    // c1 = g1 + p1*c0
    // c2 = g2 + p2*c1 = g2 + p2*g1 + p2*p1*c0
    // c3 = g3 + p3*c2 = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*c0
    // c4 = g4 + p4*c3 = g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1 + p4*p3*p2*p1*c0

    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & c[0]);
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & c[0]);

    // Sum bits
    generate
        for (i=1; i<=4; i=i+1) begin : sum_loop
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate and generate
    assign P = &p[4:1];
    assign G = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);

    assign Cout = c[4];
endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,    // Group propagate of 16 bits
    output        G     // Group generate of 16 bits
);
    wire [4:0] c;  // Carry signals for each 4-bit block boundary
    wire [3:1] P_blk, G_blk; // Propagate and generate of each 4-bit block
    wire [15:1] S_blk [3:1]; // Sum bits from each 4-bit block

    assign c[0] = Cin;

    // Instantiate 4 blocks of 4-bit CLA
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : cla4blocks
            cla_4bit cla4 (
                .A   (A[4*i+4 : 4*i+1]),
                .B   (B[4*i+4 : 4*i+1]),
                .Cin (c[i]),
                .S   (S[4*i+4 : 4*i+1]),
                .Cout(c[i+1]),
                .P   (P_blk[i+1]),
                .G   (G_blk[i+1])
            );
        end
    endgenerate

    // Calculate carry inputs to each 4-bit block using the 4-bit group CLA logic
    // The c[i] wires are from the 4-bit blocks, but need to be driven by the group generate and propagate signals

    // Carry lookahead for c[1], c[2], c[3], c[4]:
    // c[1] = G_blk[1] | (P_blk[1] & c[0])
    // c[2] = G_blk[2] | (P_blk[2] & c[1]) = G_blk[2] | (P_blk[2] & G_blk[1]) | (P_blk[2] & P_blk[1] & c[0])
    // c[3] = G_blk[3] | (P_blk[3] & c[2]) = G_blk[3] | (P_blk[3] & G_blk[2]) | (P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[3] & P_blk[2] & P_blk[1] & c[0])
    // c[4] = G_blk[4] | (P_blk[4] & c[3]) = G_blk[4] | (P_blk[4] & G_blk[3]) | (P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & c[0])

    // We have a circular dependency: c[i] are outputs of sub-blocks, but also used as input. This is resolved because actual c[i] signals are outputs of sub-blocks driven by carry in. 
    // But since c[i] inputs of sub-blocks are outputs of carry-lookahead calculation from P_blk and G_blk signals, need to override c[1]..c[4] with these direct carry calculations.

    wire c1, c2, c3, c4;
    assign c1 = G_blk[1] | (P_blk[1] & c[0]);
    assign c2 = G_blk[2] | (P_blk[2] & G_blk[1]) | (P_blk[2] & P_blk[1] & c[0]);
    assign c3 = G_blk[3] | (P_blk[3] & G_blk[2]) | (P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[3] & P_blk[2] & P_blk[1] & c[0]);
    assign c4 = G_blk[4] | (P_blk[4] & G_blk[3]) | (P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & c[0]);

    // Force carry-in to sub-blocks using the above calculated carry signals
    // To realize this, reroute carry inputs to sub-blocks and update sum output accordingly.

    // We'll instantiate sub-blocks again with re-routed c[i], or fix the code structure by instantiating the sub-blocks without outputs c[1:4], 
    // then calculate the carries in hierarchical CLA fashion and finally compute sum using p and carry-in.

    // Revised approach:

endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,    // Group propagate of 16 bits
    output        G     // Group generate of 16 bits
);
    wire [4:1] P_blk, G_blk;
    wire [64:1] p, g;  // p and g for 16 bits indexed 1 to 16
    wire [16:0] c;
    genvar i;

    assign c[0] = Cin;

    generate
        for (i=1; i<=16; i=i+1) begin : pg_loop
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Group p and g for each 4-bit block (bits 4*i to 4*i-3)
    // P_blk[i] = AND of p bits in block i
    // G_blk[i] = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 (4 bits) - carry generate for block

    generate
        for (i=1; i<=4; i=i+1) begin : block_pg
            wire [4:1] bp; // block propagate bits
            wire [4:1] bg; // block generate bits
            assign bp[1] = p[4*i-3];
            assign bp[2] = p[4*i-2];
            assign bp[3] = p[4*i-1];
            assign bp[4] = p[4*i];
            assign bg[1] = g[4*i-3];
            assign bg[2] = g[4*i-2];
            assign bg[3] = g[4*i-1];
            assign bg[4] = g[4*i];

            // Block propagate: all p in block
            assign P_blk[i] = &bp;

            // Block generate: calculate generate of 4-bit block with CLA logic:
            // G_block = g4 | p4*g3 | p4*p3*g2 | p4*p3*p2*g1
            assign G_blk[i] = bg[4] | (bp[4] & bg[3]) | (bp[4] & bp[3] & bg[2]) | (bp[4] & bp[3] & bp[2] & bg[1]);
        end
    endgenerate

    // Calculate carries at block boundaries using CLA on 4 blocks
    // c0 = Cin
    // c1 = G_blk[1] | (P_blk[1] & c0)
    // c2 = G_blk[2] | (P_blk[2] & c1) = G_blk[2] | P_blk[2]*G_blk[1] | P_blk[2]*P_blk[1]*c0
    // c3 = G_blk[3] | (P_blk[3] & c2) = ...
    // c4 = G_blk[4] | (P_blk[4] & c3) = Cout

    assign c[0] = Cin;
    assign c[4] = G_blk[4] | (P_blk[4] & (G_blk[3] | (P_blk[3] & (G_blk[2] | (P_blk[2] & (G_blk[1] | (P_blk[1] & Cin)))))));

    assign c[1] = G_blk[1] | (P_blk[1] & c[0]);
    assign c[2] = G_blk[2] | (P_blk[2] & c[1]);
    assign c[3] = G_blk[3] | (P_blk[3] & c[2]);
    assign Cout = c[4];

    // Calculate carries within each 4-bit block:
    // For each bit, c[i] = g[i] + p[i]*c[i-1]

    generate
        for (i=1; i<=16; i=i+1) begin : carry_calc
            // For bit i,
            // if i mod 4 == 1, carry in is block carry c[(i-1)/4], e.g. for bit 1 => c[0], bit 5 => c[1], bit 9 => c[2], bit 13 => c[3]
            wire carry_in;
            if ((i-1) % 4 == 0)
                assign carry_in = c[(i-1)/4];
            else
                assign carry_in = g[i-1] | (p[i-1] & carry_calc.carry_in);
            // We'll handle carry_in recursively in the generate block below.
        end
    endgenerate

    // The above recursive assignment in generate loop is not possible.
    // We implement explicitly for each bit in a generate loop with proper logic:

    wire [16:0] c_internal;
    assign c_internal[0] = Cin;

    generate
        for (i=1; i<=16; i=i+1) begin : internal_carry_loop
            if ((i-1) % 4 == 0) begin
                // carry_in from block-level carry
                assign c_internal[i] = g[i] | (p[i] & c[(i-1)/4]);
            end else begin
                assign c_internal[i] = g[i] | (p[i] & c_internal[i-1]);
            end
        end
    endgenerate

    // Sum calculation
    generate
        for (i=1; i<=16; i=i+1) begin : sum_loop
            assign S[i] = p[i] ^ c_internal[i-1];
        end
    endgenerate

    // Group propagate for whole 16 bits is AND of all p
    assign P = &p[16:1];

    // Group generate for 16 bits = G_blk4 + P_blk4*G_blk3 + P_blk4*P_blk3*G_blk2 + P_blk4*P_blk3*P_blk2*G_blk1
    assign G = G_blk[4] | (P_blk[4] & G_blk[3]) | (P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]);
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

    // Lower 16 bits CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

    // Upper 16 bits CLA: carry-in is C16 from lower block
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