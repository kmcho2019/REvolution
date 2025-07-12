// 4-bit CLA block with block propagate and generate outputs
module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P_block,  // Block propagate
    output       G_block   // Block generate
);
    wire [4:1] P;  // Propagate signals per bit
    wire [4:1] G;  // Generate signals per bit
    wire [4:0] C;  // Carry signals; C[0] = Cin

    assign C[0] = Cin;

    genvar i;
    generate
        for (i=1; i<=4; i=i+1) begin : pg_gen
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead logic within 4-bit block
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    assign Cout = C[4];

    generate
        for (i=1; i<=4; i=i+1) begin : sum_gen
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // Block propagate and generate signals for hierarchical carry lookahead
    assign P_block = &P[4:1];                    // P_block = P[1]&P[2]&P[3]&P[4]
    assign G_block = G[4] | (P[4] & G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1]);

endmodule


// 8-block carry lookahead generator for the 8 4-bit blocks
module cla_8block_carrygen (
    input  [8:1] P_block,  // Block propagate signals from 8 blocks
    input  [8:1] G_block,  // Block generate signals from 8 blocks
    input        Cin,
    output [8:1] C         // Carry-in for each block (C[1] is carry-in to block 1, equals Cin)
);
    wire [8:0] carry;       // Internal carries: carry[0] = Cin

    assign carry[0] = Cin;

    // Generate carries for each block using carry-lookahead formula:
    // carry[i] = G_block[i] | (P_block[i] & carry[i-1])
    genvar i;
    generate
        for (i=1; i<=8; i=i+1) begin : carry_calc
            assign carry[i] = G_block[i] | (P_block[i] & carry[i-1]);
        end
    endgenerate

    // Carry-in to block i is carry[i-1]
    generate
        for (i=1; i<=8; i=i+1) begin : assign_block_carryin
            assign C[i] = carry[i-1];
        end
    endgenerate

endmodule


// Top-level 32-bit carry-lookahead adder module
module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Wires for block propagate/generate signals and carry-ins
    wire [8:1] P_block;
    wire [8:1] G_block;
    wire [8:1] C_block_in;  // carry-in to each 4-bit block

    // Generate eight 4-bit CLA blocks
    genvar blk;
    generate
        for (blk=1; blk<=8; blk=blk+1) begin : blocks
            wire [4:1] A_sub;
            wire [4:1] B_sub;
            wire [4:1] S_sub;
            wire Cout_sub;
            wire P_sub, G_sub;

            assign A_sub = A[blk*4 -:4]; // Select 4 bits with MSB at higher index, respecting [32:1]
            assign B_sub = B[blk*4 -:4];

            cla_4bit cla_inst (
                .A       (A_sub),
                .B       (B_sub),
                .Cin     (C_block_in[blk]),
                .S       (S_sub),
                .Cout    (Cout_sub),
                .P_block (P_sub),
                .G_block (G_sub)
            );

            assign S[blk*4 -:4] = S_sub;
            assign P_block[blk] = P_sub;
            assign G_block[blk] = G_sub;
        end
    endgenerate

    // Generate carries for 8 blocks
    cla_8block_carrygen carrygen (
        .P_block (P_block),
        .G_block (G_block),
        .Cin     (1'b0),
        .C       (C_block_in)
    );

    // Final carry out = carry out of last 4-bit block
    // The carry-out of last block can be computed as:
    // Cout_block8 = G_block8 | (P_block8 & C_block_in[8])
    // But C_block_in[8] is carry-in to block 8, and carrygen already computes carry[8]
    // So we compute Cout from last block's 4-bit CLA

    // Instantiate last block again for its Cout or recompute carry-out directly:
    // Alternatively, since C_block_in[9] not defined, compute last carry-out as:
    // last block carry-out = G_block[8] | (P_block[8] & C_block_in[8])

    assign C32 = G_block[8] | (P_block[8] & C_block_in[8]);

endmodule