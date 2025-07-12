module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P, // block propagate
    output wire        G  // block generate
);
    wire [7:0] p; // propagate bits
    wire [7:0] g; // generate bits
    wire [8:0] c; // carry signals

    assign p = A ^ B;     // propagate
    assign g = A & B;     // generate
    assign c[0] = Cin;

    // Carry lookahead logic within 8 bits:
    // c[i+1] = g[i] + p[i]*c[i]
    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign S = p ^ c[7:0];
    assign Cout = c[8];

    // Block propagate = all p bits ANDed
    assign P = &p;

    // Block generate: hierarchical lookahead for the 8-bit block generate:
    // G = g7 + p7*g6 + p7*p6*g5 + ... + p7*p6*...*p0*Cin
    // Here Cin is input carry, so G includes full block carry generate.
    wire [8:0] G_chain;
    assign G_chain[0] = Cin;
    generate
        for(i = 0; i < 8; i = i + 1) begin : gen_chain
            assign G_chain[i+1] = g[i] | (p[i] & G_chain[i]);
        end
    endgenerate
    assign G = G_chain[8];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs [32:1] to zero-based [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for(idx=0; idx < 32; idx=idx+1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into four 8-bit chunks
    wire [7:0] A_blk [3:0];
    wire [7:0] B_blk [3:0];
    generate
        for(idx=0; idx<4; idx=idx+1) begin : split_blocks
            assign A_blk[idx] = A_int[8*idx +: 8];
            assign B_blk[idx] = B_int[8*idx +: 8];
        end
    endgenerate

    // Wires for sums, carry-outs, block propagate and generate
    wire [7:0] S_blk [3:0];
    wire       C_blk [3:0]; // carry out from each 8-bit block
    wire       P_blk [3:0]; // block propagate
    wire       G_blk [3:0]; // block generate

    // Internal carry signals for blocks (carry ins for blocks 1,2,3)
    wire C_in_blk [3:0];
    assign C_in_blk[0] = 1'b0; // initial carry-in = 0

    // Instantiate 8-bit CLA blocks
    genvar b;
    generate
        for(b=0; b < 4; b = b + 1) begin : cla8_blocks
            cla_8bit cla8_inst (
                .A(A_blk[b]),
                .B(B_blk[b]),
                .Cin(C_in_blk[b]),
                .S(S_blk[b]),
                .Cout(C_blk[b]),
                .P(P_blk[b]),
                .G(G_blk[b])
            );
        end
    endgenerate

    // Carry lookahead at block level to generate carry-in for blocks 1, 2, 3
    // Using hierarchical CLA for 4 blocks:
    // C_in_blk[1] = G_blk[0] | (P_blk[0] & C_in_blk[0])
    // C_in_blk[2] = G_blk[1] | (P_blk[1] & C_in_blk[1])
    // C_in_blk[3] = G_blk[2] | (P_blk[2] & C_in_blk[2])

    // Compute carries for blocks 1 to 3:
    assign C_in_blk[1] = G_blk[0] | (P_blk[0] & C_in_blk[0]);
    assign C_in_blk[2] = G_blk[1] | (P_blk[1] & C_in_blk[1]);
    assign C_in_blk[3] = G_blk[2] | (P_blk[2] & C_in_blk[2]);

    // Final carry-out is carry-out of last block
    assign C32 = C_blk[3];

    // Map sum outputs back to [32:1]
    generate
        for(idx=0; idx < 4; idx = idx + 1) begin : sum_map_blocks
            for(int j=0; j<8; j=j+1) begin : sum_map_bits
                // global bit index = 8*idx + j
                assign S[8*idx + j + 1] = S_blk[idx][j];
            end
        end
    endgenerate
endmodule