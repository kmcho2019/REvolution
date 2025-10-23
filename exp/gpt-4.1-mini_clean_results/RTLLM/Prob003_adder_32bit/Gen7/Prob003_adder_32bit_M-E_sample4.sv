module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P,    // block propagate
    output wire        G     // block generate
);
    wire [7:0] p_bit; // propagate per bit
    wire [7:0] g_bit; // generate per bit
    wire [8:0] c;     // carries, c[0] = Cin

    assign p_bit = A ^ B;
    assign g_bit = A & B;
    assign c[0] = Cin;

    // carry lookahead for bits 0 to 7:
    // c[i+1] = g[i] + p[i]*c[i]
    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : carry_gen
            assign c[i+1] = g_bit[i] | (p_bit[i] & c[i]);
        end
    endgenerate

    assign S = p_bit ^ c[7:0];
    assign Cout = c[8];

    // Block propagate = p[7] & ... & p[0]
    assign P = &p_bit;

    // Block generate = G = g[7] + p[7]*g[6] + p[7]*p[6]*g[5] + ... + p[7]*...*p[0]*Cin
    // Since Cin is arbitrary, we compute block generate as:
    // G = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | ... | (p[7]&...&p[0]&Cin)
    // Here, since Cin is input, block generate is only g/generate signals.

    // We'll compute cumulative generate signals
    wire [8:0] Gc;
    assign Gc[0] = 1'b0;
    generate
        for (i = 1; i <= 8; i = i + 1) begin : block_gen_chain
            assign Gc[i] = g_bit[i-1] | (p_bit[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G = Gc[8];

endmodule


module cla_4bit_blocks (
    input  wire [3:0] P,
    input  wire [3:0] G,
    input  wire       Cin,
    output wire [4:0] C  // Carry outputs: C[0]=Cin, C[1]..C[4] carry outs for blocks 0..3
);
    // Compute carries in 4-bit CLA fashion:
    // C[i+1] = G[i] + P[i]*C[i]
    assign C[0] = Cin;
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : carry_block
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map input vectors [32:1] to [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for(idx=0; idx<32; idx=idx+1) begin : map_input
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into 4 blocks of 8 bits
    wire [7:0] A_blk[3:0];
    wire [7:0] B_blk[3:0];

    generate
        for (idx=0; idx<4; idx=idx+1) begin : split_blocks
            assign A_blk[idx] = A_int[8*idx +: 8];
            assign B_blk[idx] = B_int[8*idx +: 8];
        end
    endgenerate

    // Wires to connect block sums, propagates, generates, and carries
    wire [7:0] S_blk [3:0];
    wire       P_blk [3:0];
    wire       G_blk [3:0];
    wire       C_blk [4:0]; // carry ins to each 8-bit block, C_blk[0] = Cin=0

    assign C_blk[0] = 1'b0; // external carry-in is 0

    // Instantiate 8-bit CLA blocks with carry-in from top-level carry outputs
    genvar b;
    generate
        for (b=0; b<4; b=b+1) begin : cla8_blocks
            cla_8bit cla8 (
                .A(A_blk[b]),
                .B(B_blk[b]),
                .Cin(C_blk[b]),
                .S(S_blk[b]),
                .Cout(),   // unused directly, carry out passed via block generate signals
                .P(P_blk[b]),
                .G(G_blk[b])
            );
        end
    endgenerate

    // Instantiate 4-bit CLA block for block carry generation
    cla_4bit_blocks cla4 (
        .P({P_blk[3], P_blk[2], P_blk[1], P_blk[0]}),
        .G({G_blk[3], G_blk[2], G_blk[1], G_blk[0]}),
        .Cin(1'b0),
        .C(C_blk)
    );

    // Final carry-out of 32-bit adder is carry-out of last block
    assign C32 = C_blk[4];

    // Map block sums back to S[32:1]
    generate
        for (idx=0; idx<4; idx=idx+1) begin : map_sum
            for (int j=0; j<8; j=j+1) begin : map_bits
                assign S[8*idx + j + 1] = S_blk[idx][j];
            end
        end
    endgenerate
endmodule