module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,    // Block propagate
    output wire       G     // Block generate
);
    wire [3:0] P_bit; // Propagate per bit
    wire [3:0] G_bit; // Generate per bit
    wire [4:0] C;     // Carry signals

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    // Carry lookahead logic for each bit
    genvar i;
    generate
        for (i = 0; i < 4; i = i +1) begin : carry_calc
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[3:0];
    assign Cout = C[4];

    // Block propagate is AND of all bit propagates
    assign P = &P_bit;

    // Block generate: hierarchical generate
    // G = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    wire g01 = G_bit[0];
    wire g12 = G_bit[1] | (P_bit[1] & g01);
    wire g23 = G_bit[2] | (P_bit[2] & g12);
    assign G = G_bit[3] | (P_bit[3] & g23);
endmodule

module cla_8bit (
    input  wire [7:0] A,  // Here used as block propagates (P)
    input  wire [7:0] B,  // Here used as block generates (G)
    input  wire       Cin,
    output wire [7:0] S,  // Carries out to feed lower blocks (carry-ins for 4-bit blocks)
    output wire       Cout,
    output wire       P,   // Block propagate
    output wire       G    // Block generate
);
    wire [7:0] P_bit; // Propagate per bit
    wire [7:0] G_bit; // Generate per bit
    wire [8:0] C;     // Carry signals

    assign P_bit = A;
    assign G_bit = B;
    assign C[0] = Cin;

    // Carry lookahead for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_calc
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = C[7:0]; // Carry-ins for next blocks
    assign Cout = C[8];

    // Block propagate is AND of all bit propagates
    assign P = &P_bit;

    // Block generate: hierarchical generate
    // G = G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P0*Cin
    // Build prefix generate:
    wire [8:0] Gc;
    assign Gc[0] = 1'b0;
    generate
        for (i=1; i<=8; i=i+1) begin : prefix_generate
            assign Gc[i] = G_bit[i-1] | (P_bit[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G = Gc[8];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based indexing
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx=0; idx<32; idx=idx+1) begin : map_inputs
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Eight 4-bit blocks
    wire [3:0] A_block [7:0];
    wire [3:0] B_block [7:0];
    wire [3:0] S_block [7:0];
    wire       P_block [7:0];
    wire       G_block [7:0];
    wire       C_block [7:0]; // Carry-in to each 4-bit block (except first)

    // Slice inputs into blocks
    generate
        for (idx=0; idx<8; idx=idx+1) begin : slice_blocks
            assign A_block[idx] = A_int[4*idx +: 4];
            assign B_block[idx] = B_int[4*idx +: 4];
        end
    endgenerate

    // Carry-in to first block is 0
    assign C_block[0] = 1'b0;

    // CLA blocks instantiated without carry-in yet
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : cla4_blocks
            cla_4bit cla4 (
                .A(A_block[i]),
                .B(B_block[i]),
                .Cin(C_block[i]),
                .S(S_block[i]),
                .Cout(),         // unused here
                .P(P_block[i]),
                .G(G_block[i])
            );
        end
    endgenerate

    // Now use an 8-bit CLA to compute carry-in for each 4-bit block
    // Inputs: P_block and G_block are block propagate and generate signals from 4-bit blocks
    wire [7:0] carry_ins;
    wire       carry_out_8;
    wire       P_8, G_8;

    cla_8bit cla8 (
        .A(P_block),
        .B(G_block),
        .Cin(1'b0),
        .S(carry_ins),
        .Cout(carry_out_8),
        .P(P_8),
        .G(G_8)
    );

    // Assign carry-in signals for blocks 1 to 7
    generate
        for (i=1; i<8; i=i+1) begin : assign_carries
            assign C_block[i] = carry_ins[i-1];
        end
    endgenerate

    // Re-instantiate 4-bit CLAs with correct carry-in signals and generate sums
    // Because carry_in changed, sum must be recomputed
    // To avoid duplication, use a combinational generate loop with local wires
    // Instead of re-instantiating, use intermediate wires:

    // We'll instantiate a second set of cla_4bit to get sums with carry-ins assigned from carry_ins
    // Or update C_block[0]=0, and for i=1..7 use carry_ins[i-1]
    wire [3:0] S_block_final [7:0];
    generate
        for (i=0; i<8; i=i+1) begin : cla4_blocks_final
            cla_4bit cla4_final (
                .A(A_block[i]),
                .B(B_block[i]),
                .Cin( (i==0) ? 1'b0 : carry_ins[i-1] ),
                .S(S_block_final[i]),
                .Cout(),  // Unused
                .P(),     // Unused
                .G()      // Unused
            );
        end
    endgenerate

    // Concatenate final sum blocks to output sum [32:1]
    generate
        for (i=0; i<8; i=i+1) begin : assign_sum_out
            for (idx=0; idx<4; idx=idx+1) begin : assign_bits
                assign S[4*i + idx +1] = S_block_final[i][idx];
            end
        end
    endgenerate

    // Final carry out is carry_out_8 from 8-bit CLA on block P/G signals
    assign C32 = carry_out_8;

endmodule