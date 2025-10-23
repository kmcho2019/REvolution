module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       Cin,
    output wire [7:0] S,
    output wire       Cout,
    output wire       P_block,
    output wire       G_block
);
    // Per-bit propagate and generate signals
    wire [7:0] P = A ^ B;
    wire [7:0] G = A & B;

    // Carry signals: C[0] = Cin
    wire [8:0] C;
    assign C[0] = Cin;

    // Carry lookahead logic for each bit:
    // C[i+1] = G[i] | (P[i] & C[i])
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[7:0];

    assign Cout = C[8];

    // Block propagate = AND of all P bits
    assign P_block = &P;

    // Block generate computed as recursive prefix generate:
    // G_block = G[7] | (P[7] & G[6]) | ... | (P[7]&...&P[0]&Cin)
    wire [7:0] gen_prefix;
    assign gen_prefix[0] = G[0];
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_prefix_loop
            assign gen_prefix[i] = G[i] | (P[i] & gen_prefix[i-1]);
        end
    endgenerate
    assign G_block = gen_prefix[7];
endmodule


module cla_4block (
    input  wire [3:0] P, // Block propagate inputs
    input  wire [3:0] G, // Block generate inputs
    input  wire       Cin,
    output wire [3:0] C, // Carry-ins for blocks 1,2,3,4 (C[0] = Cin)
    output wire       P_block,
    output wire       G_block
);
    // Carry lookahead logic for blocks:
    // C[i+1] = G[i] | (P[i] & C[i])
    // C[0] = Cin is input carry-in, C[1], C[2], C[3] are block carry-ins for blocks 1,2,3 respectively
    // C[4] is carry-out of the full 4-block adder (not output here)

    // Internally, define C_internal with length 5
    wire [4:0] C_int;
    assign C_int[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_block
            assign C_int[i+1] = G[i] | (P[i] & C_int[i]);
        end
    endgenerate

    // Output carry-ins for blocks 1,2,3,4 (C[0]..C[3] corresponds to carry-ins for block1..block4)
    assign C = C_int[3:0];

    // Block propagate = AND of all P inputs
    assign P_block = &P;

    // Block generate = prefix generate of block G,P signals:
    // G_block = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) | (P[3]&P[2]&P[1]&P[0]&Cin)
    wire [3:0] gen_prefix_block;
    assign gen_prefix_block[0] = G[0];
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_prefix_block_loop
            assign gen_prefix_block[i] = G[i] | (P[i] & gen_prefix_block[i-1]);
        end
    endgenerate
    assign G_block = gen_prefix_block[3];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based indexing for inputs
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_mapping
            assign A_int[idx] = A[idx + 1];
            assign B_int[idx] = B[idx + 1];
        end
    endgenerate

    // Split input into four 8-bit blocks
    wire [7:0] A_blk [3:0];
    wire [7:0] B_blk [3:0];
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : blk_assign
            assign A_blk[idx] = A_int[(idx*8)+7 : idx*8];
            assign B_blk[idx] = B_int[(idx*8)+7 : idx*8];
        end
    endgenerate

    // Wires for sum outputs and carry-out from each 8-bit block
    wire [7:0] S_blk [3:0];
    wire       Cout_blk [3:0];
    wire       P_blk [3:0];
    wire       G_blk [3:0];

    // Internal carry inputs for blocks from CLA of block PG signals
    wire [3:0] C_blk_in; // Carry-in signals for blocks

    // Carry-in for block 0 is zero (no external carry-in)
    // Declare for passing to blocks
    assign C_blk_in[0] = 1'b0;

    // Instantiate four 8-bit CLA blocks
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : cla8_inst
            cla_8bit cla8 (
                .A(A_blk[idx]),
                .B(B_blk[idx]),
                .Cin(C_blk_in[idx]),
                .S(S_blk[idx]),
                .Cout(Cout_blk[idx]),
                .P_block(P_blk[idx]),
                .G_block(G_blk[idx])
            );
        end
    endgenerate

    // Instantiate 4-block CLA for generating carry-ins for blocks 1,2,3
    // Input: block propagates and generates, carry-in = 0
    cla_4block cla4 (
        .P(P_blk),
        .G(G_blk),
        .Cin(1'b0),
        .C(C_blk_in),
        .P_block(),
        .G_block()
    );

    // Final carry-out is carry-out from block 3 (highest block)
    assign C32 = Cout_blk[3];

    // Assemble output sum bits [32:1]
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : sum_assemble
            for (int bit=0; bit < 8; bit=bit+1) begin : bit_loop
                assign S[idx*8 + bit + 1] = S_blk[idx][bit];
            end
        end
    endgenerate

endmodule