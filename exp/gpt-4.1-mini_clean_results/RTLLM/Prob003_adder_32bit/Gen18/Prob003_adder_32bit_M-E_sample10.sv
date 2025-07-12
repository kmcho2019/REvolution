module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       Cin,
    output reg  [7:0] S,
    output reg        Cout,
    output reg        P,  // Block propagate
    output reg        G   // Block generate
);
    // Internal propagate and generate signals
    wire [7:0] p; // propagate
    wire [7:0] g; // generate
    reg  [8:0] c; // carry signals, c[0] = Cin

    integer i;

    assign p = A ^ B;
    assign g = A & B;

    always @(*) begin
        c[0] = Cin;
        // Carry lookahead: c[i+1] = g[i] | (p[i] & c[i])
        for (i = 0; i < 8; i = i + 1) begin
            c[i+1] = g[i] | (p[i] & c[i]);
        end
        // Sum bits
        for (i = 0; i < 8; i = i + 1) begin
            S[i] = p[i] ^ c[i];
        end
        Cout = c[8];
        // Block propagate: all bits propagate = p[7]&...&p[0]
        P = &p;
        // Block generate: G = g[7] | (p[7]&g[6]) | (p[7]&p[6]&g[5]) | ... (carry generate of whole block)
        // Compute block generate via prefix chain:
        reg tmp_g;
        integer j;
        tmp_g = g[0];
        for (j = 1; j < 8; j = j + 1) begin
            tmp_g = g[j] | (p[j] & tmp_g);
        end
        G = tmp_g;
    end
endmodule


module cla_4bit_blk (
    input  wire [3:0] P,   // block propagate signals from lower level blocks
    input  wire [3:0] G,   // block generate signals from lower level blocks
    input  wire       Cin,
    output reg  [3:0] C,   // carry-in to each 8-bit block
    output reg        Cout,
    output reg        P_blk,  // Propagate for this 4-block level
    output reg        G_blk   // Generate for this 4-block level
);
    // Carry lookahead for blocks: C[0] = carry into block0 (=Cin), C[i] = carry into block i (i>0)
    // C[i] = G[i-1] + P[i-1] * C[i-1]

    integer i;

    always @(*) begin
        C[0] = Cin;
        for (i = 1; i < 4; i = i + 1) begin
            C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
        Cout = G[3] | (P[3] & C[3]);
        P_blk = &P;  // All blocks propagate
        // Block generate: hierarchical prefix for block generate
        // G_blk = G[3] + P[3]*G[2] + P[3]*P[2]*G[1] + P[3]*P[2]*P[1]*G[0]
        reg tmp_g;
        integer j;
        tmp_g = G[0];
        for (j = 1; j < 4; j = j + 1) begin
            tmp_g = G[j] | (P[j] & tmp_g);
        end
        G_blk = tmp_g;
    end
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map to zero-based for internal processing
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for(idx=0; idx<32; idx=idx+1) begin : map_inp
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Wires for 8-bit CLA blocks outputs
    wire [7:0] S_blocks [3:0];
    wire       Couts [3:0];
    wire       P_blocks [3:0];
    wire       G_blocks [3:0];

    // Carries into each 8-bit block (4 blocks)
    wire [3:0] carries;

    // Instantiate four 8-bit CLA blocks
    generate
        for(idx=0; idx<4; idx=idx+1) begin : cla8_blocks
            cla_8bit cla8 (
                .A(A_int[8*idx +: 8]),
                .B(B_int[8*idx +: 8]),
                .Cin(carries[idx]),
                .S(S_blocks[idx]),
                .Cout(Couts[idx]),
                .P(P_blocks[idx]),
                .G(G_blocks[idx])
            );
        end
    endgenerate

    // Instantiate 4-bit CLA to compute carries into each 8-bit block
    // carry[0] = global carry-in = 0 (no external Cin given)
    // The carries array is carries[0..3], where carries[0]=0, carries[i>0] computed from 4-bit CLA
    // The carry-in for the 4-bit CLA is zero.
    wire P_blk_4, G_blk_4;
    reg  [3:0] carry_ins_4;

    always @(*) begin
        carry_ins_4[0] = 1'b0; // Initial carry-in at block level = 0
        // carry_ins_4[1..3] will be computed by 4-bit CLA blk outputs
    end

    cla_4bit_blk cla4blk (
        .P(P_blocks),
        .G(G_blocks),
        .Cin(1'b0),
        .C(carry_ins_4),
        .Cout(),  // Not used here
        .P_blk(P_blk_4),
        .G_blk(G_blk_4)
    );

    // Assign block carries from 4-bit CLA block outputs (carry_ins_4 from cla4blk)
    // Because carry_ins_4[0]=0 is manually assigned, and cla4blk generates all carries C[0..3]
    // We'll override carry_ins_4 in a wire to reflect this:
    wire [3:0] block_carries = carry_ins_4;

    // Now, assign carries into each 8-bit block accordingly:
    // block_carries[0]=Cin=0 to first block
    // block_carries[1] = carry into block1
    // block_carries[2] = carry into block2
    // block_carries[3] = carry into block3

    // Since in Verilog continuous assignment can't be done on reg inside always,
    // Use wires and assign:

    wire [3:0] carries_w;
    assign carries_w = carry_ins_4;

    // Output carry of entire 32-bit adder is carry out from last 8-bit block
    assign C32 = Couts[3];

    // Assign output sum bits
    generate
        for(idx=0; idx<4; idx=idx+1) begin : sum_assign
            for(integer j=0; j<8; j=j+1) begin
                assign S[8*idx + j +1] = S_blocks[idx][j];
            end
        end
    endgenerate

    // Now connect carries input of each 8-bit block:
    // As the cla8_blocks instances were connected to carries[idx],
    // But we want carries to come from block_carries (output of cla4blk),
    // So we need to connect carries[idx] to block_carries[idx].

    // Use a generate block to assign carries array wires:
    // But carries is a wire array, defined in generate block of cla8_blocks,
    // Instead of internal reg, declare carries as wire [3:0] and assign:

    // Define carries wire:
    wire [3:0] carries;
    assign carries = block_carries;

endmodule