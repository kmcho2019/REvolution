module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [7:0] P_bit;  // propagate per bit
    wire [7:0] G_bit;  // generate per bit
    wire [8:0] C;      // carry signals

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : carry_loop
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[7:0];
    assign Cout = C[8];

    // Block propagate = AND of all P_bit
    assign P = &P_bit;

    // Block generate = carry generate for entire block:
    // G = G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P0*Cin
    // Implement via a chain accumulating generates
    wire [8:0] Gb; // intermediate generate signals
    assign Gb[0] = 1'b0;
    generate
        for (i=1; i<=8; i=i+1) begin : gen_chain
            assign Gb[i] = G_bit[i-1] | (P_bit[i-1] & Gb[i-1]);
        end
    endgenerate
    assign G = Gb[8];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors for mapping
    wire [31:0] A_int, B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Divide into four 8-bit blocks
    wire [7:0] A_blk[3:0];
    wire [7:0] B_blk[3:0];
    wire [7:0] S_blk[3:0];
    wire       P_blk[3:0];
    wire       G_blk[3:0];
    wire       C_blk[4:0];  // Carry into blocks: C_blk[0] = Cin=0

    assign C_blk[0] = 1'b0; // external carry-in

    // Map inputs per 8-bit block
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : blk_map
            assign A_blk[idx] = A_int[(8*idx)+7 -: 8];
            assign B_blk[idx] = B_int[(8*idx)+7 -: 8];
        end
    endgenerate

    // Instantiate 8-bit CLA blocks
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : cla_blocks
            cla_8bit cla_inst (
                .A(A_blk[idx]),
                .B(B_blk[idx]),
                .Cin(C_blk[idx]),
                .S(S_blk[idx]),
                .Cout(),      // Not needed as we compute carry out differently
                .P(P_blk[idx]),
                .G(G_blk[idx])
            );
        end
    endgenerate

    // Compute carries between blocks using carry-lookahead logic over block P and G signals
    // C_blk[i+1] = G_blk[i] + P_blk[i]*C_blk[i] for i=0..3
    // Since C_blk[0]=0, carry chain:
    // C_blk[1] = G_blk[0] + P_blk[0]*0 = G_blk[0]
    // C_blk[2] = G_blk[1] + P_blk[1]*C_blk[1]
    // C_blk[3] = G_blk[2] + P_blk[2]*C_blk[2]
    // C_blk[4] = G_blk[3] + P_blk[3]*C_blk[3] = C32

    // Unroll this chain explicitly:
    assign C_blk[1] = G_blk[0];                                 // carry into block 1
    assign C_blk[2] = G_blk[1] | (P_blk[1] & C_blk[1]);
    assign C_blk[3] = G_blk[2] | (P_blk[2] & C_blk[2]);
    assign C_blk[4] = G_blk[3] | (P_blk[3] & C_blk[3]);
    assign C32 = C_blk[4];

    // Recompute sums for blocks 1..3 with proper carry-ins (since initially carry-in was zero)
    // The sum depends on carry-in, so reinstantiate blocks with correct carry-in.
    // To avoid double instantiation, create separate instances for blocks 1..3 with correct carry-in.

    // We'll instantiate a new set of blocks with proper carry-ins:

    wire [7:0] S_blk_final[3:0];

    // Block 0 sum is correct (C_blk[0] = 0)
    assign S_blk_final[0] = S_blk[0];

    // For blocks 1..3, reinstantiate cla_8bit with proper carry-in
    generate
        for (idx = 1; idx < 4; idx = idx +1) begin : cla_blocks_corrected
            cla_8bit cla_inst_corr (
                .A(A_blk[idx]),
                .B(B_blk[idx]),
                .Cin(C_blk[idx]),
                .S(S_blk_final[idx]),
                .Cout(),    // Not used here
                .P(),       // Not used here
                .G()
            );
        end
    endgenerate

    // Map final sums back to output bus [32:1]
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : sum_out_map
            for (int bit=0; bit < 8; bit = bit + 1) begin : sum_bits
                assign S[(8*idx) + bit + 1] = S_blk_final[idx][bit];
            end
        end
    endgenerate

endmodule